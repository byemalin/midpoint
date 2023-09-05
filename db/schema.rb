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

ActiveRecord::Schema[7.0].define(version: 2023_09_05_143753) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "airports", force: :cascade do |t|
    t.string "airport_code", null: false
    t.string "city_name", null: false
    t.string "country_name", null: false
    t.float "latitude"
    t.float "longitude"
    t.string "suggestions"
  end

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
    t.datetime "local_arrival_1"
    t.datetime "local_arrival_2"
    t.bigint "airport_to_id"
    t.index ["airport_to_id"], name: "index_destinations_on_airport_to_id"
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
    t.string "city_from_1"
    t.string "city_from_2"
    t.bigint "airport_from_1_id"
    t.bigint "airport_from_2_id"
    t.index ["airport_from_1_id"], name: "index_meetups_on_airport_from_1_id"
    t.index ["airport_from_2_id"], name: "index_meetups_on_airport_from_2_id"
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "destinations", "airports", column: "airport_to_id"
  add_foreign_key "destinations", "meetups"
  add_foreign_key "meetups", "airports", column: "airport_from_1_id"
  add_foreign_key "meetups", "airports", column: "airport_from_2_id"
  add_foreign_key "meetups", "users"
end
