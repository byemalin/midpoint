class Meetup < ApplicationRecord
  has_many :destinations, dependent: :destroy
  belongs_to :user
  belongs_to :airport_from_1, class_name: "Airport", optional: true
  belongs_to :airport_from_2, class_name: "Airport", optional: true

  validates :fly_from_1, presence: true
  validates :fly_from_2, presence: true
  validates :date_from, presence: true
end
