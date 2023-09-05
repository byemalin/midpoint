class AddSuggestionsToAirports < ActiveRecord::Migration[7.0]
  def change
    add_column :airports, :suggestions, :string
  end
end
