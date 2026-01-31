require "net/http"
require "json"
require "time"

class WeatherFetcher
  def self.call(latitude, longitude, timezone)
    response = Net::HTTP.get(URI("https://api.open-meteo.com/v1/forecast?latitude=#{latitude}&longitude=#{longitude}&daily=temperature_2m_max,temperature_2m_min&timezone=#{timezone}&temperature_unit=fahrenheit"))
    weather = JSON.parse(response)

    unless response["error"]
      weekdays = weather["daily"]["time"].map { |value| Time.parse(value).strftime("%A") }
      high_temps = weather["daily"]["temperature_2m_max"]
      low_temps = weather["daily"]["temperature_2m_min"]

      weekdays.zip(high_temps, low_temps).map do |day, high, low|
        { weekday: day, high_temp: high, low_temp: low }
      end
    end
  end
end
