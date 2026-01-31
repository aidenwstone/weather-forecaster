require 'rails_helper'

RSpec.describe "Locations", type: :request do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }

  before do
    sign_in user1
  end

  describe "GET /locations" do
    let!(:user1_loc1) { create(:location, name: "Test Location 1", user: user1) }
    let!(:user1_loc2) { create(:location, name: "Test Location 2", user: user1) }
    let!(:user2_loc1) { create(:location, name: "Test Location 3", user: user2) }

    before do
      get locations_path
    end

    it 'returns a successful response' do
      expect(response).to have_http_status(:ok)
    end

    it "returns the current user's locations" do
      expect(response.body).to include(user1_loc1.name)
      expect(response.body).to include(user1_loc2.name)
    end

    it "does not return anyone else's locations" do
      expect(response.body).not_to include(user2_loc1.name)
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

    context "when valid parameters are submitted" do
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

    context "when invalid parameters are submitted" do
      it "does not increase the count of the user's locations" do
        expect { post "/locations", params: params_invalid }.not_to change(user1.locations, :count)
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
    let!(:user_loc) { create(:location, user: user1) }

    it "decreases the count of the user's locations" do
      expect { delete location_path(user_loc) }.to change(user1.locations, :count).by(-1)
    end

    context "after the request" do
      before do
        delete location_path(user_loc)
      end

      it "redirects to index page" do
        expect(response).to redirect_to(locations_path)
      end

      it "sends a success flash message" do
        expect(flash[:notice]).to eq("Location was successfully deleted!")
      end
    end
  end
end
