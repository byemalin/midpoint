require "json"
require "open-uri"
require 'net/http'

class FlightApi

# 1. Based on input, 2 URLs will be created (date [same: date_from & date_to], dep_city-1) & (date, dep_city-2)
# https://api.tequila.kiwi.com/v2/search?date_from=25/09/2023&fly_from=CDG&date_to=25/09/2023&sort=price&limit=500
# https://api.tequila.kiwi.com/v2/search?date_from=25/09/2023&fly_from=HND&date_to=25/09/2023&sort=price&limit=500

# 2. Obtain two arrays of 500 flights sorted by price from dep_city-1 & dep_city-2
# 3. Create an array that contains only information about the airport code, city, and price
# 4. Only select unique cities from that array

  def destinations(fly_from_1, fly_from_2, date)
  depart_input_1 = File.read("db/seeds/CDG.json") # Fake json data (comment when using API)
    depart_1 = JSON.parse(depart_input_1) # Fake json data (comment when using API)

    # #API call for city_from_1 (comment when using fake seeds)
    # uri_1 = URI("https://api.tequila.kiwi.com/v2/search?date_from=#{date}&fly_from=#{fly_from_1}&date_to=#{date}&sort=price&limit=500")
    # req = Net::HTTP::Get.new(uri_1)
    # req['apikey'] = ENV["APIKEY_TEQUILA"]
    # res = Net::HTTP.start(uri_1.hostname, uri_1.port, use_ssl: uri_1.scheme == 'https') { |http|
    #   http.request(req)
    # }
    # depart_input_1 = res.body
    # depart_1 = JSON.parse(depart_input_1)
    # #end

    depart_1_city_price = depart_1['data'].map do |info|
      {
        fly_to: info['flyTo'],
        price: info['price'],
        city_to: info['cityTo'],
        country_to: info['countryTo']['name'],
        local_departure: info['local_departure'],
        local_arrival: info['local_arrival'],
        duration: info['duration']['departure'],
        airlines: info['airlines'],
        deep_link: info['deep_link'],
        has_airport_change: info['has_airport_change']
      }
    end

    depart_1_filtered = depart_1_city_price.uniq { |info| info[:city_to] }

    depart_input_2 = File.read("db/seeds/OSL.json") # Fake json data (comment when using API)
    depart_2 = JSON.parse(depart_input_2) # Fake json data (comment when using API)

    # #API call for city_from_2 (comment when using fake seeds)
    # uri_2 = URI("https://api.tequila.kiwi.com/v2/search?date_from=#{date}&fly_from=#{fly_from_2}&date_to=#{date}&sort=price&limit=500")
    # req = Net::HTTP::Get.new(uri_2)
    # req['apikey'] = ENV["APIKEY_TEQUILA"]
    # res = Net::HTTP.start(uri_2.hostname, uri_2.port, use_ssl: uri_2.scheme == 'https') { |http|
    #   http.request(req)
    # }
    # depart_input_2 = res.body
    # depart_2 = JSON.parse(depart_input_2)
    # #end

    depart_2_city_price = depart_2['data'].map do |info|
      {
        fly_to: info['flyTo'],
        price: info['price'],
        city_to: info['cityTo'],
        country_to: info['countryTo']['name'],
        local_departure: info['local_departure'],
        local_arrival: info['local_arrival'],
        duration: info['duration']['departure'],
        airlines: info['airlines'],
        deep_link: info['deep_link'],
        has_airport_change: info['has_airport_change']
      }
    end

    depart_2_filtered = depart_2_city_price.uniq { |info| info[:city_to] }

    # 5. In 1st filtered ordered array find the first city which matches the city from 2nd filtered ordered array
    results_matched = []

    depart_1_filtered.each do |info1|
      fly_to_1 = info1[:fly_to]
      price_1 = info1[:price]

      depart_2_filtered.each do |info2|
        fly_to_2 = info2[:fly_to]
        price_2 = info2[:price]

        if fly_to_2 == fly_to_1
          total_price = price_1 + price_2
          results_matched << {
                                total_price: total_price,

                                city_to_1: info1[:city_to],
                                fly_to_1: info1[:fly_to],
                                country_to_1: info1[:country_to],

                                price_1: info1[:price],
                                local_departure_1: info1[:local_departure],
                                local_arrival_1: info1[:local_arrival],
                                duration_1: info1[:duration],
                                airlines_1: info1[:airlines],
                                deep_link_1: info1[:deep_link],
                                has_airport_change_1: info1[:has_airport_change],

                                price_2: info2[:price],
                                local_departure_2: info2[:local_departure],
                                local_arrival_2: info2[:local_arrival],
                                duration_2: info2[:duration],
                                airlines_2: info2[:airlines],
                                deep_link_2: info2[:deep_link],
                                has_airport_change_2: info2[:has_airport_change]
                            }
        end
      end
    end
    # 6. Store this into an array of destinations [{city_to_1: "Miami", fly_to_1: "MIA", price_1: 50, ...} ... ]
    results_matched_srt = results_matched.sort_by { |price| price[:total_price] }
  end
end
