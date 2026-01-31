require_relative '../../app/services/weather_fetcher'

RSpec.describe WeatherFetcher do
  describe '#call' do
    context 'when valid coordinates are provided' do
      let(:json_response_valid) {
        JSON.dump({
          "daily": {
            "time": [
              "2026-01-31",
              "2026-02-01",
              "2026-02-02",
              "2026-02-03",
              "2026-02-04",
              "2026-02-05",
              "2026-02-06"
            ],
            "temperature_2m_max": [ 20.7, 22.1, 29.9, 31.3, 30.2, 28.7, 32.1 ],
            "temperature_2m_min": [ 6.7, 7.1, 5, 6.8, 14, 12.5, 9.9 ]
          }
        })
      }
      let(:weather_fetcher_result_valid) {
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

      it 'calls the weather API and returns the correct data' do
        expect(Net::HTTP).to receive(:get).and_return(json_response_valid)
        result = WeatherFetcher.call(40.67480, -73.97139, 'America/New_York')
        expect(result).to eq(weather_fetcher_result_valid)
      end
    end

    context 'when invalid coordinates are provided' do
        let(:json_response_invalid) {
          JSON.dump({
            "error": true,
            "reason": "Latitude must be in range of -90 to 90°. Given: 100.0."
          })
        }

        it 'calls the Weather API and returns an error' do
          expect(Net::HTTP).to receive(:get).and_return(json_response_invalid)
          result = WeatherFetcher.call(100.0, -73.97139, 'America/New_York')
          expect(result).to be_nil
        end
    end
  end
end
