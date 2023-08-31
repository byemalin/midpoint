class AddCoordinatesToDestinations < ActiveRecord::Migration[7.0]
  def change
    add_column :destinations, :latitute, :float
    add_column :destinations, :longitude, :float
  end
end
