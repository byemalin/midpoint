class Destination < ApplicationRecord
  belongs_to :meetup
  has_many :flights, dependent: :destroy

  geocoded_by :fly_to

  def total_price
    self.price_1 + self.price_2
  end
end
