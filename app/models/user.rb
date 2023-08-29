class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :user_meetups
  has_many :flights
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
