class Airport < ApplicationRecord
  AIRPORT_NAMES = {
    "ATL" => "Hartsfield-Jackson Atlanta International Airport",
    "PEK" => "Beijing Capital International Airport",
  }

  has_many :destinations, dependent: :destroy
  has_many :meetups_from_1, dependent: :destroy, foreign_key: :airport_from_1_id, class_name: "Meetup"
  has_many :meetups_from_2, dependent: :destroy, foreign_key: :airport_from_2_id, class_name: "Meetup"
  belongs_to :user
  has_one_attached :city_photo
end
