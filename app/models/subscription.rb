# Created for tracking receipients (solution submitter and commeter) to send a
# new comment notification.
class Subscription < ActiveRecord::Base
  belongs_to :solution
  belongs_to :user
end
