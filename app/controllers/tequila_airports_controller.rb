class TequilaAirportsController < ApplicationController
  def index
    response = HTTP.get(
      "https://api.tequila.kiwi.com/locations/query",
      params: {
        term: params[:term],
        locale: "en-US",
        location_types: "airport",
        limit: 10,
        active_only: true
      },
      headers: {
        accept: "application/json",
        apikey: ENV["APIKEY_TEQUILA"]
      }
    )
    render(json: response.parse)
  end
end
