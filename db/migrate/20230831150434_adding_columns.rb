class AddingColumns < ActiveRecord::Migration[7.0]
  def change
    add_column :destinations, :local_arrival_1, :datetime
    add_column :destinations, :local_arrival_2, :datetime
    add_column :meetups, :city_from_1, :string
    add_column :meetups, :city_from_2, :string
  end
end
