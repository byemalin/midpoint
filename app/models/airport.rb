class Airport < ApplicationRecord
  AIRPORT_NAMES = {
    "ATL" => "Hartsfield-Jackson Atlanta International Airport",
    "PEK" => "Beijing Capital International Airport",
  }

  has_many :destinations, foreign_key: :airport_to_id, dependent: :destroy
  has_many :meetups_from_1, dependent: :destroy, foreign_key: :airport_from_1_id, class_name: "Meetup"
  has_many :meetups_from_2, dependent: :destroy, foreign_key: :airport_from_2_id, class_name: "Meetup"
  has_one_attached :city_photo

  geocoded_by :city_name
end
