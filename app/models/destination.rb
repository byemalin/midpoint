class Destination < ApplicationRecord
  belongs_to :meetup
  has_many :flights, dependent: :destroy
end
