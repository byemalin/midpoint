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

ActiveRecord::Schema[7.0].define(version: 2023_08_31_150434) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "destinations", force: :cascade do |t|
    t.bigint "meetup_id", null: false
    t.boolean "is_midpoint"
    t.boolean "is_recommended"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "fly_to_code"
    t.string "fly_to_city"
    t.string "fly_to_country"
    t.float "price_1"
    t.float "price_2"
    t.datetime "local_departure_1"
    t.datetime "local_departure_2"
    t.integer "duration_1"
    t.integer "duration_2"
    t.string "airlines_1"
    t.string "airlines_2"
    t.string "deep_link_1"
    t.string "deep_link_2"
    t.boolean "has_airport_change_1"
    t.boolean "has_airport_change_2"
    t.float "latitude"
    t.float "longitude"
    t.datetime "local_arrival_1"
    t.datetime "local_arrival_2"
    t.index ["meetup_id"], name: "index_destinations_on_meetup_id"
  end

  create_table "meetups", force: :cascade do |t|
    t.date "date_from"
    t.date "date_to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "fly_from_1"
    t.string "fly_from_2"
    t.bigint "user_id"
    t.float "departure_city1_lat"
    t.float "departure_city1_lon"
    t.float "departure_city2_lat"
    t.float "departure_city2_lon"
    t.string "city_from_1"
    t.string "city_from_2"
    t.index ["user_id"], name: "index_meetups_on_user_id"
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
  add_foreign_key "meetups", "users"
end
