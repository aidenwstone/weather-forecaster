require 'rails_helper'

RSpec.describe Location, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_numericality_of(:latitude).is_in(-90..90).allow_nil }

    it { should validate_numericality_of(:longitude).is_in(-180..180).allow_nil }

    describe '#has_address_or_ip' do
      context 'when :address is provided' do
        it 'is valid' do
          location = build(:location)
          expect(location).to be_valid
        end
      end

      context 'when :ip_address is provided' do
        it 'is valid' do
          location = build(:location, :with_ip)
          expect(location).to be_valid
        end
      end

      context 'when neither :address nor :ip_address is provided' do
        it 'is invalid and returns the correct error' do
          location = build(:location, address: nil, ip_address: nil)
          location.valid?
          expect(location.errors[:base]).to include("Must include either 'address' or 'ip_address'")
        end
      end
    end
  end
end
