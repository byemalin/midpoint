class CreateUserMeetUps < ActiveRecord::Migration[7.0]
  def change
    create_table :user_meet_ups do |t|
      t.references :user, null: false, foreign_key: true
      t.references :meetup, null: false, foreign_key: true
      t.string :fly_from

      t.timestamps
    end
  end
end
