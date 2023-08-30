class MeetupsController < ApplicationController
  def create
    @meetup = Meetup.new(meetup_params)
    @meetup.user = current_user
    if @meetup.save
      results = FlightApi.new.destinations(@meetup.fly_from_1, @meetup.fly_from_2, @meetup.date_from)
      destinations = results.map do |destination|
        [destination[:fly_to_1], destination[:total_price]]
      end
    end

      redirect_to meetup_path(@meetup)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def meetup_params
    params.require(:meetup).permit(:fly_from_1, :fly_from_2, :date_from)
  end
end
