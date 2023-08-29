class CreateFlights < ActiveRecord::Migration[7.0]
  def change
    create_table :flights do |t|
      t.references :destination, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :price
      t.integer :duration

      t.timestamps
    end
  end
end
