class Destination < ApplicationRecord
  belongs_to :meetup
  has_one_attached :city_photo
  belongs_to :airport_to, class_name: "Airport"

  def total_price
    price_1 + price_2
  end

  def city_img_url
    if airport_to.country_code != "US" && airport_to.country_code != "CA"
      "https://images.skypicker.com/?image=https%3A%2F%2Fimages.kiwi.com%2Fphotos%2F1280x720%2F#{fly_to_city.downcase.parameterize}_#{airport_to.country_code.downcase}.jpg"
    elsif airport_to.city_photo.attached?
      Rails.application.url_helpers.cl_image_path airport_to.city_photo.key
    else
      "stock/oslo-stock.jpg"
    end
  end
end
