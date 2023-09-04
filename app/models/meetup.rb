class Meetup < ApplicationRecord
  has_many :destinations, dependent: :destroy
  belongs_to :user
  belongs_to :airport_from_1, class_name: "Airport"

  # validates :name, presence: true
end
