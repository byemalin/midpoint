# Midpoint
## Meet In The Middle

A flight searching site that helps travelers find the best midpoint destinations for meeting up with friends and family.

![Image](https://www.midpoint.world/assets/logo_cover-eda98110d2113ae27e13ca0f50eb4f6e792fddb2681d2f61f6f5270bbd72d583.png)

If in later versions user authentication is required check the following:
#1 Model User.rb: uncomment has_many and devise
#2 Model meetup.rb: uncomment belongs_to :user
#3 application_controller: uncomment before_action
#4 pages_controller: uncomment skip_before_action
#5 meetupds_controller: uncomment: @meetup.user = current_user
#6 _navbar view: uncomment if user_signed_in?

#to run on localhost: redis-server + sidekiq
