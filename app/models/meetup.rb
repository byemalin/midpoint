class Meetup < ApplicationRecord
  has_many :destinations, dependent: :destroy
  has_many :user_meetups, dependent: :destroy

  validates :name, presence: true
end
