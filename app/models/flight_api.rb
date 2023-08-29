class FlightApi
  def

  end
end


# require "json"
# require "open-uri"

# url = "https://api.github.com/users/ssaunier"
# user_serialized = URI.open(url).read
user_input_1 = File.read("db/seeds/CDG.json")
user_1 = JSON.parse(user_input_1)

user_input_2 = File.read("db/seeds/MIA.json")
user_2 = JSON.parse(user_input_2)

# 1. Based on input 2 URLs will be created (date [same: date_from & date_to], dep_city-1) & (date, dep_city-2)
# https://api.tequila.kiwi.com/v2/search?date_from=25/09/2023&fly_from=CDG&date_to=25/09/2023&sort=price&limit=500
# https://api.tequila.kiwi.com/v2/search?date_from=25/09/2023&fly_from=HND&date_to=25/09/2023&sort=price&limit=500

# 2. Obtain two arrays of 500 flights sorted by price from dep_city-1 & dep_city-2

# 1 - fly_to & price_1 [ MIA $80]
# 2 - fly_to & price_2 [ MIA $50]

# 3. In this sorted order find the first city from the array-1 which matches the city from array-2

# 4. Add this match into a new array of destinations

# [["MIA", 80, 50], ["NHK", 90, 80], ["NYC", 54, 50]]

# 5. Repeat this for each city from array-1

# 6. Now we have an array of destinations (matched destination cities). Sort it by price. Display 10 top.

# [["MIA", ], ["NHK", 90, 80], ["NYC", 54, 50]].sort_by { |a, b, c| b + c}

# 7. Save 10 top destinations with 2 flights for each
