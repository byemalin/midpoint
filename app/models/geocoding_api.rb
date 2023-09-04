require "json"
require "open-uri"
require 'net/http'

class GeocodingApi
  def get_coords(destination)
    uri_1 = URI("https://api.mapbox.com/geocoding/v5/mapbox.places/#{CGI.escape(destination)}.json?access_token=#{ENV["MAPBOX_API_KEY"]}")
    req = Net::HTTP::Get.new(uri_1)
    # req['apikey'] = ENV["MAPBOX_API_KEY"]
    res = Net::HTTP.start(uri_1.hostname, uri_1.port, use_ssl: uri_1.scheme == 'https') { |http|
      http.request(req)
    }
    response = res.body
    jsonResponse = JSON.parse(response)

    jsonResponse["features"].first["geometry"]["coordinates"].reverse
    # puts jsonResponse[:coordinates]
    # depart_input_1 = res.body
    # depart_1 = JSON.parse(depart_input_1)

  end
end
