require 'rails_helper'

RSpec.describe "Locations", type: :request do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }

  before do
    sign_in user1
  end

  describe "GET /locations/:id" do
    let!(:user1_loc) { create(:location, user: user1) }
    let(:weather_fetcher_result) {
      [
        { weekday: 'Saturday', high_temp: 20.7, low_temp: 6.7 },
        { weekday: 'Sunday', high_temp: 22.1, low_temp: 7.1 },
        { weekday: 'Monday', high_temp: 29.9, low_temp: 5 },
        { weekday: 'Tuesday', high_temp: 31.3, low_temp: 6.8 },
        { weekday: 'Wednesday', high_temp: 30.2, low_temp: 14 },
        { weekday: 'Thursday', high_temp: 28.7, low_temp: 12.5 },
        { weekday: 'Friday', high_temp: 32.1, low_temp: 9.9 }
      ]
    }

    before do
      allow(WeatherFetcher).to receive(:call).and_return(weather_fetcher_result)
    end

    it "calls WeatherFetcher with the correct coordinates" do
      expect(WeatherFetcher).to receive(:call).with(user1_loc.latitude, user1_loc.longitude, user1_loc.timezone)
      get location_path(user1_loc)
    end

    context "when WeatherFetcher returns a result array" do
      it "renders the 7-day forecast" do
        get location_path(user1_loc)

        weather_fetcher_result.each do |day|
          expect(response.body).to include(day[:weekday])
          expect(response.body).to include(day[:high_temp].to_s)
          expect(response.body).to include(day[:low_temp].to_s)
        end
      end
    end

    context "when WeatherFetcher returns :unreachable" do
      before do
        allow(WeatherFetcher).to receive(:call).and_return(:unreachable)
      end

      it "renders a 'server not responding' message" do
        get location_path(user1_loc)

        expect(response.body).to include("Hmmm... We couldn't get the weather data right now. Maybe try again later.")
      end
    end
  end

  describe "GET /locations" do
    let!(:user1_loc1) { create(:location, nickname: "Test Location 1", user: user1) }
    let!(:user1_loc2) { create(:location, nickname: "Test Location 2", user: user1) }
    let!(:user2_loc1) { create(:location, nickname: "Test Location 3", user: user2) }

    before do
      get locations_path
    end

    it 'returns a successful response' do
      expect(response).to have_http_status(:ok)
    end

    it "returns the current user's locations" do
      expect(response.body).to include(user1_loc1.nickname)
      expect(response.body).to include(user1_loc2.nickname)
    end

    it "does not return anyone else's locations" do
      expect(response.body).not_to include(user2_loc1.nickname)
    end
  end

  describe "GET /locations/new" do
    before do
      get new_location_path
    end

    it "returns a successful response" do
      expect(response).to have_http_status(:ok)
    end

    it "renders a form for a new location" do
      expect(response.body).to include("form")
      expect(response.body).to include('name="location[address]"')
      expect(response.body).to include('name="location[ip_address]"')
    end
  end

  describe "POST /locations" do
    let(:params_valid) { { location: { address: "New York, NY", ip_address: "" } } }
    let(:params_invalid) { { location: { address: "", ip_address: "" } } }
    let(:result_valid) { { latitude: 40.67480, longitude: -73.97139, name: 'New York', timezone: 'America/New_York' } }

    context "when valid parameters are submitted" do
      context "when LocationFinder returns a result hash" do
        before do
          allow(LocationFinder).to receive(:call).and_return(result_valid)
        end

        it "increases the count of the user's locations" do
          expect { post "/locations", params: params_valid }.to change(user1.locations, :count).by(1)
        end

        context "after the request" do
          before do
            post "/locations", params: params_valid
          end

          it "redirects to index page" do
            expect(response).to redirect_to(locations_path)
          end

          it "sends a success flash message" do
            expect(flash[:notice]).to eq("Location successfully added!")
          end
        end
      end

      context "when LocationFinder returns nil" do
        before do
          allow(LocationFinder).to receive(:call).and_return(nil)
        end

        it "does not increase the count of the user's locations" do
          expect { post "/locations", params: params_valid }.not_to change(user1.locations, :count)
        end

        context "after the request" do
          before do
            post "/locations", params: params_valid
          end

          it "returns an unprocessable content response" do
            expect(response).to have_http_status(:unprocessable_content)
          end

          it "shows the error message" do
            expect(response.body).to include("1 error prohibited this location from being saved:")
          end
        end
      end

      context "when LocationFinder returns :unreachable" do
        before do
          allow(LocationFinder).to receive(:call).and_return(:unreachable)
        end

        it "does not increase the count of the user's locations" do
          expect { post "/locations", params: params_valid }.not_to change(user1.locations, :count)
        end

        context "after the request" do
          before do
            post "/locations", params: params_valid
          end

          it "returns a service unavailable response" do
            expect(response).to have_http_status(:service_unavailable)
          end

          it "sends a 'server not responding' flash message" do
            expect(flash[:alert]).to eq("Uh oh, looks like the server is not responding. Please try again later.")
          end
        end
      end
    end

    context "when invalid parameters are submitted" do
      it "does not increase the count of the user's locations" do
        expect { post "/locations", params: params_invalid }.not_to change(user1.locations, :count)
      end

      it "does not call LocationFinder" do
        expect(LocationFinder).not_to receive(:call)
      end

      context "after the request" do
        before do
          post "/locations", params: params_invalid
        end

        it "returns an unprocessable content response" do
          expect(response).to have_http_status(:unprocessable_content)
        end

        it "shows the error message" do
          expect(response.body).to include("1 error prohibited this location from being saved:")
        end
      end
    end
  end

  describe "DELETE /locations/:id" do
    let!(:user1_loc) { create(:location, user: user1) }

    it "decreases the count of the user's locations" do
      expect { delete location_path(user1_loc) }.to change(user1.locations, :count).by(-1)
    end

    context "after the request" do
      before do
        delete location_path(user1_loc)
      end

      it "redirects to index page" do
        expect(response).to redirect_to(locations_path)
      end

      it "sends a success flash message" do
        expect(flash[:notice]).to eq("Location was successfully deleted!")
      end
    end

    context "when attempting to delete another user's location" do
      let!(:user2_loc) { create(:location, user: user2) }

      it "returns a not found response" do
        delete location_path(user2_loc)
        expect(response).to have_http_status(:not_found)
      end

      it "does not delete the location" do
        expect { delete location_path(user2_loc) }.not_to change(user2.locations, :count)
      end
    end
  end
end
