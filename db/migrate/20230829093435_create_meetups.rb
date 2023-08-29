class CreateMeetups < ActiveRecord::Migration[7.0]
  def change
    create_table :meetups do |t|
      t.date :date_from
      t.date :date_to

      t.timestamps
    end
  end
end
