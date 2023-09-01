class MeetupsController < ApplicationController
  def create
    # @meetup = Meetup.new(meetup_params)
    # dep_city1_coords = get_coords(params[:fly_from_1])
    # dep_city2_coords = get_coords(params[:fly_from_2])
    @meetup = Meetup.new(
      # name: "MEETUP TEST",
      fly_from_1: params[:fly_from_1],
      fly_from_2: params[:fly_from_2],
      date_from: params[:date_from],
      # departure_city1_lat: dep_city1_coords[0],
      # departure_city1_lon: dep_city1_coords[1],
      # departure_city2_lat: dep_city2_coords[0],
      # departure_city2_lon: dep_city2_coords[1]
      # Add 4 new properties for departure cities
    )

    calculate_midpoint(@meetup)

    @meetup.user = current_user
    if @meetup.save
      results = FlightApi.new.destinations(@meetup.fly_from_1, @meetup.fly_from_2, @meetup.date_from)
      results.each do |info|
        coords = get_coords(info[:city_to_1])
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
          # longitude:coords[1]
        )
      end
      redirect_to meetup_path(@meetup)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @meetup = Meetup.find(params[:id])
    @destinations = @meetup.destinations
    @markers = @destinations.geocoded.map do |destination|
      {
        lat: destination.latitude,
        lng: destination.longitude
      }
    end
  end

  private

  def meetup_params
    # params.require(:meetups).permit(:fly_from_1, :fly_from_2, :date_from)
  end

  def get_coords(destination_name)
    # results = Geocoder.search(destination_name)
    # results.first.coordinates
    puts destination_name
    results = Geocoder.search(destination_name)
    results.first.coordinates
  end

  def calculate_midpoint(meetup)
    midpoint = ([(meetup.departure_city1_lat + meetup.departure_city1_lon)/2,(meetup.departure_city2_lat + meetup.departure_city2_lon) / 2])
    puts midpoint
  end
end
