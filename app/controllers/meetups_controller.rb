class MeetupsController < ApplicationController
  def create
    # @meetup = Meetup.new(meetup_params)
#     dep_city1_coords = get_coords(params[:fly_from_1])
#     dep_city2_coords = get_coords(params[:fly_from_2])

    @meetup = Meetup.new(
      # name: "MEETUP TEST",
      fly_from_1: params[:fly_from_1],
      fly_from_2: params[:fly_from_2],
      date_from: params[:date_from],
      departure_city1_lat: 48.8566,
      departure_city1_lon: 2.3522,
      departure_city2_lat: 59.9319,
      departure_city2_lon: 10.7522
      # departure_city1_lat: dep_city1_coords[0],
      # departure_city1_lon: dep_city1_coords[1],
      # departure_city2_lat: dep_city2_coords[0],
      # departure_city2_lon: dep_city2_coords[1]
      # Store coords in a city table, create a new city if doesn't exist already
      # Add 4 new properties for departure cities
    )

    @meetup.user = current_user
    if @meetup.save
      results = FlightApi.new.destinations(@meetup.fly_from_1, @meetup.fly_from_2, @meetup.date_from)
      @meetup.update(city_from_1: results.first[:city_from_1], city_from_2: results.first[:city_from_2])

      results.each do |info|
        # coords = get_coords(info[:city_to_1])
        # next unless coords

        Destination.create!(
          meetup_id: @meetup.id,
          is_midpoint: false,
          is_recommended: false,
          fly_to_code: info[:fly_to_1],
          fly_to_city: info[:city_to_1],
          fly_to_country: info[:country_to_1],
          price_1:info[:price_1],
          price_2:info[:price_2],
          local_departure_1: info[:local_departure_1],
          local_departure_2: info[:local_departure_2],
          local_arrival_1: info[:local_arrival_1],
          local_arrival_2: info[:local_arrival_2],
          duration_1: info[:duration_1],
          duration_2: info[:duration_2],
          airlines_1: info[:airlines_1],
          airlines_2: info[:airlines_2],
          deep_link_1: info[:deep_link_1],
          deep_link_2: info[:deep_link_2],
          has_airport_change_1: info[:has_airport_change_1],
          has_airport_change_2: info[:has_airport_change_2],
          # latitude: coords[0],
          # longitude: coords[1]
          )
          # unsplash_url = "https://api.unsplash.com/photos/random?client_id=#{ENV["ACCESS_KEY"]}&query=#{fly_to_city}"
          # photo_serialized = URI.open(unsplash_url).read
          # photo_json = JSON.parse(photo_serialized)
          # photo_url = photo_json["urls"]["small"]
          # photo_url = Unsplash::Photo.search("#{info[:city_to_1]}, #{info[:country_to_1]}").first[:urls][:small]
          # file = URI.open(photo_url)
          # destination.photo.attach(io: file, filename: "fly_to_city.png", content_type: "image/png")
          # destination.save!
          # latitude: coords[0],
          # longitude:coords[1]

      end
      # find_midpoint(@meetup)
      redirect_to meetup_path(@meetup)
    else
      render :new, status: :unprocessable_entity
    end
    # iterate over destinations and set midpoint flag to true for closest
  end

  def show
    @meetup = Meetup.find(params[:id])

    case params[:sort]
    when "total_price"
      order = "price_1 + price_2"
    when "total_duration"
      order = "duration_1 + duration_2"
    else
      order = "duration_1 * price_1 + duration_2 * price_2"
    end

    @destinations = @meetup.destinations.order(Arel.sql(order)).limit(10)

    @markers = @destinations.geocoded.map do |destination|
      {
        lat: destination.latitude,
        lng: destination.longitude
      }
    end
    # @midpoint_destination = @destinations.find_by(is_midpoint: true)
  end

  private

  def meetup_params
    # params.require(:meetups).permit(:fly_from_1, :fly_from_2, :date_from)
  end

  # def get_coords(destination_name)
  #   results = Geocoder.search(destination_name)
  #   if results.empty?
  #     return
  #   end
  #   results.first.coordinates
  # end

  # def find_midpoint(meetup)
  #   midpoint = ([(meetup.departure_city1_lat + meetup.departure_city1_lon)/2,(meetup.departure_city2_lat + meetup.departure_city2_lon) / 2])
  #   midpoint_destination = meetup.destinations.near(midpoint).first
  #   puts "This is the #{midpoint_destination}"
  #   midpoint_destination.update(is_midpoint: true)
  # end
end
