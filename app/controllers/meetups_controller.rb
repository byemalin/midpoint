class MeetupsController < ApplicationController

  def index
  end
  
  def show
    authorize @meetup
    @destinations = Destination.all
    # iterate over the destinations
  end

  def create
    authorize @meetup

  end

  def delete
    authorize @meetup
  end

  def update
    @meetup = Meetup.find(params[:id])
    authorize @meetup
    @meetup.update
  end
end
