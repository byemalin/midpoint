class AddCountryCodeToToDestination < ActiveRecord::Migration[7.0]
  def change
    add_column :airports, :country_code, :string
  end
end
