class UserMeetUp < ApplicationRecord
  belongs_to :user
  belongs_to :meetup
end
