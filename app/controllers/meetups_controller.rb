class MeetupsController < ApplicationController
  def create

    # dep_city1_coords = GeocodingApi.new.get_coords(params[:fly_from_1])
    # dep_city2_coords = GeocodingApi.new.get_coords(params[:fly_from_2])

    @meetup = Meetup.new(
      fly_from_1: params[:fly_from_1].last(3),
      fly_from_2: params[:fly_from_2].last(3),
      date_from: params[:date_from],

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
      @meetup.update(
        city_from_1: results.first[:city_from_1],
        city_from_2: results.first[:city_from_2],
        fly_from_1: results.first[:fly_from_1],
        fly_from_2: results.first[:fly_from_2],

        airport_from_1: find_or_create_airport(
          airport_code: results.first[:fly_from_1],
          city_name: results.first[:city_from_1],
          country_name: results.first[:country_from_1],
          country_code: results.first[:country_code_1]
        ),

        airport_from_2: find_or_create_airport(
          airport_code: results.first[:fly_from_2],
          city_name: results.first[:city_from_2],
          country_name: results.first[:country_from_2],
          country_code: results.first[:country_code_2]
        )
      )

      results.each do |info|

        Destination.create!(
          meetup_id: @meetup.id,
          airport_to: find_or_create_airport(
            airport_code: info[:fly_to_1],
            city_name: info[:city_to_1],
            country_name: info[:country_to_1],
            country_code: info[:country_code_to_1],
          ),
          is_midpoint: false,
          is_recommended: false,
          fly_to_code: info[:fly_to_1],
          fly_to_city: info[:city_to_1],
          fly_to_country: info[:country_to_1],
          price_1: info[:price_1],
          price_2: info[:price_2],
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
        )
      end
      find_midpoint(@meetup)
      redirect_to meetup_path(@meetup)
    else
      # binding.irb
      flash.now[:alert] = @meetup.errors.full_messages.to_sentence
      render "pages/home", status: :unprocessable_entity
    end
    # iterate over destinations and set midpoint flag to true for closest
  end

  def show
    @meetup = Meetup.find(params[:id])

    case params[:sort]
    when 'total_price'
      order = 'price_1 + price_2'
    when 'total_duration'
      order = 'duration_1 + duration_2'
    else
      order = 'duration_1 * price_1 + duration_2 * price_2'
    end

    @destinations = @meetup.destinations.order(Arel.sql(order)).limit(10)

    @markers = @destinations.map do |destination|
      {
        id: destination.id,
        lat: destination.airport_to.latitude,
        lng: destination.airport_to.longitude
      }
    end
    @midpoint_destination = @destinations.find_by(is_midpoint: true)
  end

  private

  def meetup_params
    params.require(:meetups).permit(:fly_from_1, :fly_from_2, :date_from, :city_to_1)
  end

  def get_coords(destination_name)
    GeocodingApi.new.get_coords(destination_name)
    # results = Geocoder.search(destination_name)
    # if results.empty?
    #   return
    # end
    # puts destination_name
    # results.first.coordinates
  end

  def find_midpoint(meetup)
    midpoint = Geocoder::Calculations.geographic_center([
      [meetup.airport_from_1.latitude, meetup.airport_from_1.longitude],
      [meetup.airport_from_2.latitude, meetup.airport_from_2.longitude]
    ])
    midpoint_airport = Airport.near(midpoint, 3000, units: :km).where(id: meetup.destinations.pluck(:airport_to_id)).first
    midpoint_destination = meetup.destinations.find_by(airport_to_id: midpoint_airport)
    # puts "This is the #{midpoint_destination}"
    if midpoint_destination
      midpoint_destination.update(is_midpoint: true)
    end
  end

  def city_photo_upload(airport)
    if airport.country_code == "us" || airport.country_code == "ca"
      begin
      # unsplash_url = "https://api.unsplash.com/photos/random?client_id=#{ENV["UNSPLASH_ACCESS_KEY"]}&query=#{CGI.escape(city_name)}"
      # photo_serialized = URI.open(unsplash_url).read
      # photo_json = JSON.parse(photo_serialized)
      # photo_url = photo_json["urls"]["small"]
        photo_url = Unsplash::Photo.search("#{airport.city_name}, #{airport.country_name}").first[:urls][:small]
        file = URI.open(photo_url)
        airport.city_photo.attach(io: file, filename: "city_name.png", content_type: "image/png")
        airport.save!
      rescue Unsplash::Error
      end
    end
  end

  def find_or_create_airport(airport_code:, city_name:, country_name:, country_code:)
    airport = Airport.find_by(airport_code: airport_code)
    if airport
      unless airport.city_photo.attached?
        city_photo_upload(airport)
      end

      unless airport.suggestions.present?
        FindSuggestionsJob.perform_later(airport)
      end
    else
      coords = get_coords("#{city_name}, #{country_name}")
      airport = Airport.create!(
        airport_code: airport_code,
        city_name: city_name,
        country_name: country_name,
        country_code: country_code,
        latitude: coords[0],
        longitude: coords[1],
      )
      city_photo_upload(airport)
      FindSuggestionsJob.perform_later(airport)
    end
    airport
  end
end
