class Meetup < ApplicationRecord
  has_many :destinations, dependent: :destroy
  belongs_to :user

  validates :name, presence: true
end
