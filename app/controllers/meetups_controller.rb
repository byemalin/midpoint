class MeetupsController < ApplicationController
  def create
    # raise
    # @meetup = Meetup.new(meetup_params)
    @meetup = Meetup.new(
      # name: "MEETUP TEST",
      fly_from_1: params[:fly_from_1],
      fly_from_2: params[:fly_from_2],
      date_from: params[:date_from]
    )
    @meetup.user = current_user
    if @meetup.save
      results = FlightApi.new.destinations(@meetup.fly_from_1, @meetup.fly_from_2, @meetup.date_from)
      results.each do |info|
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
          duration_1: info[:duration_1],
          duration_2: info[:duration_2],
          airlines_1: info[:airlines_1],
          airlines_2: info[:airlines_2],
          deep_link_1: info[:deep_link_1],
          deep_link_2: info[:deep_link_2],
          has_airport_change_1: info[:has_airport_change_1],
          has_airport_change_2: info[:has_airport_change_2]
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
        lng: destination.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: {destination: destination})
      }
    end
    # destinations = results.map do |destination|
    #   [destination[:fly_to_1], destination[:total_price]]
    # end
  end

  private
  def meetup_params
    # params.require(:meetups).permit(:fly_from_1, :fly_from_2, :date_from)
  end
end
