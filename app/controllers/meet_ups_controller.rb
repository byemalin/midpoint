class MeetUpsController < ApplicationController
  def show
    authorize @meetup
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
