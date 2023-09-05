class Destination < ApplicationRecord
  belongs_to :meetup
  # has_one_attached :photo
  belongs_to :airport_to, class_name: "Airport"

  def total_price
    self.price_1 + self.price_2
  end
end
