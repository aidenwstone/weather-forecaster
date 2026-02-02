require "net/http"
require "json"

class LocationFinder
  def self.call(address, ip_address)
    if !address.empty?
      response = Net::HTTP.get(URI("https://geocode.xyz/?locate=#{address}&json=1&moreinfo=1"))
      loc = JSON.parse(response)

      unless loc["error"]
        { latitude: loc["latt"].to_f, longitude: loc["longt"].to_f, name: loc["standard"]["city"], timezone: loc["timezone"] }
      end
    elsif !ip_address.empty?
      response = Net::HTTP.get(URI("https://ipapi.co/#{ip_address}/json"))
      loc = JSON.parse(response)

      unless loc["error"]
        { latitude: loc["latitude"], longitude: loc["longitude"], name: loc["city"], timezone: loc["timezone"] }
      end
    end
  rescue
    :unreachable
  end
end
