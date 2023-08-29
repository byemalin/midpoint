class CreateDestinations < ActiveRecord::Migration[7.0]
  def change
    create_table :destinations do |t|
      t.references :meetup, null: false, foreign_key: true
      t.string :airport_code
      t.boolean :midpoint?
      t.string :country
      t.boolean :recommended?
      t.string :fly_to
      t.string :city_name

      t.timestamps
    end
  end
end
