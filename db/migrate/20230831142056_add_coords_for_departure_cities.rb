class AddCoordsForDepartureCities < ActiveRecord::Migration[7.0]
  def change
    add_column :meetups, :departure_city1_lat, :float
    add_column :meetups, :departure_city1_lon, :float
    add_column :meetups, :departure_city2_lat, :float
    add_column :meetups, :departure_city2_lon, :float
  end
end
