class DestinationsController < ApplicationController
  def show
    @destination = Destination.find(params[:id])
    @meetup = @destination.meetup
  end

  def summary
    @destination = Destination.find(params[:id])
  end
end
