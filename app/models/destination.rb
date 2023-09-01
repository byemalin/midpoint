class Destination < ApplicationRecord
  belongs_to :meetup
  has_many :flights, dependent: :destroy
  has_one_attached :photo

  geocoded_by :fly_to_city

  def total_price
    self.price_1 + self.price_2
  end
end
