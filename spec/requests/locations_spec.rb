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
end
