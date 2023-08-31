class RemovingFlights < ActiveRecord::Migration[7.0]
  def change
    drop_table "flights"
    drop_table "user_meet_ups"
    add_column "meetups", "fly_from_1", :string
    add_column "meetups", "fly_from_2", :string
    add_reference "meetups", :user, foreign_key: true
    remove_column "destinations", "airport_code"
    remove_column "destinations", "city_name"
    remove_column "destinations", "fly_to"
    add_column "destinations", "fly_to_code", :string
    add_column "destinations", "fly_to_city", :string
    add_column "destinations", "fly_to_country", :string
    add_column "destinations", "price_1", :float
    add_column "destinations", "price_2", :float
    add_column "destinations", "local_departure_1", :datetime
    add_column "destinations", "local_departure_2", :datetime
    add_column "destinations", "duration_1", :integer
    add_column "destinations", "duration_2", :integer
    add_column "destinations", "airlines_1", :string
    add_column "destinations", "airlines_2", :string
    add_column "destinations", "deep_link_1", :string
    add_column "destinations", "deep_link_2", :string
    add_column "destinations", "has_airport_change_1", :boolean
    add_column "destinations", "has_airport_change_2", :boolean
  end
end
