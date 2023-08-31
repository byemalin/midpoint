# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_08_31_091951) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "destinations", force: :cascade do |t|
    t.bigint "meetup_id", null: false
    t.string "airport_code"
    t.boolean "midpoint?"
    t.string "country"
    t.boolean "recommended?"
    t.string "fly_to"
    t.string "city_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitute"
    t.float "longitude"
    t.index ["meetup_id"], name: "index_destinations_on_meetup_id"
  end

  create_table "flights", force: :cascade do |t|
    t.bigint "destination_id", null: false
    t.bigint "user_id", null: false
    t.integer "price"
    t.integer "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["destination_id"], name: "index_flights_on_destination_id"
    t.index ["user_id"], name: "index_flights_on_user_id"
  end

  create_table "meetups", force: :cascade do |t|
    t.date "date_from"
    t.date "date_to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_meet_ups", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "meetup_id", null: false
    t.string "fly_from"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["meetup_id"], name: "index_user_meet_ups_on_meetup_id"
    t.index ["user_id"], name: "index_user_meet_ups_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "destinations", "meetups"
  add_foreign_key "flights", "destinations"
  add_foreign_key "flights", "users"
  add_foreign_key "user_meet_ups", "meetups"
  add_foreign_key "user_meet_ups", "users"
end
