require_relative '../../app/services/location_finder'

RSpec.describe LocationFinder do
  describe '#call' do
    context 'when a valid address is provided' do
      let(:json_response_geocode_valid) {
        JSON.dump({
          "standard": {
            "city": "New York"
          },
          "longt": "-73.97139",
          "latt": "40.67480",
          "timezone": "America/New_York"
        })
      }

      it 'calls the geocoding API and returns the correct data' do
        expect(Net::HTTP).to receive(:get).and_return(json_response_geocode_valid)
        result = LocationFinder.call('New York, NY', '')
        expect(result).to eq({ latitude: 40.67480, longitude: -73.97139, name: 'New York', timezone: 'America/New_York' })
      end
    end

    context 'when an invalid address is provided' do
      let(:json_response_geocode_invalid) {
        JSON.dump({
          "error": {
            "description": "Your request produced no suggestions.",
            "code": "018"
          }
        })
      }

      it 'calls the geocoding API and returns nil' do
        expect(Net::HTTP).to receive(:get).and_return(json_response_geocode_invalid)
        result = LocationFinder.call('Invalid', '')
        expect(result).to be_nil
      end
    end

    context 'when a valid IP address is provided' do
      let(:json_response_ipapi_valid) {
        JSON.dump({
          "city": "Mountain View",
          "latitude": 37.386,
          "longitude": -122.0838,
          "timezone": "America/Los_Angeles"
        })
      }

      it 'calls the IP location API and returns the correct data' do
        expect(Net::HTTP).to receive(:get).and_return(json_response_ipapi_valid)
        result = LocationFinder.call('', '192.0.2.0')
        expect(result).to eq({ latitude: 37.386, longitude: -122.0838, name: 'Mountain View', timezone: 'America/Los_Angeles' })
      end
    end

    context 'when an invalid IP address is provided' do
      let(:json_response_ipapi_invalid) {
        JSON.dump({
          "error": true,
          "reason": "Invalid IP Address"
        })
      }

      it 'calls the IP location API and returns nil' do
        expect(Net::HTTP).to receive(:get).and_return(json_response_ipapi_invalid)
        result = LocationFinder.call('', '192.0.2')
        expect(result).to be_nil
      end
    end
  end
end
