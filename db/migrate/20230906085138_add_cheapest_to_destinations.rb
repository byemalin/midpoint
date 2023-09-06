class AddCheapestToDestinations < ActiveRecord::Migration[7.0]
  def change
    add_column :destinations, :is_cheapest, :boolean
  end
end
