class UpdateAirport < ActiveRecord::Migration[7.0]
  def change
    remove_column "destinations", "latitude"
    remove_column "destinations", "longitude"

    remove_column "meetups", "departure_city1_lat"
    remove_column "meetups", "departure_city1_lon"
    remove_column "meetups", "departure_city2_lat"
    remove_column "meetups", "departure_city2_lon"

    create_table :airports do |t|
      t.string :airport_code, null: false
      t.string :city_name, null: false
      t.string :country_name, null: false
      t.float :latitude
      t.float :longitude
    end

    add_reference "destinations", "airport_to", foreign_key: { to_table: :airports }
    add_reference "meetups", "airport_from_1", foreign_key: { to_table: :airports }
    add_reference "meetups", "airport_from_2", foreign_key: { to_table: :airports }
  end
end
