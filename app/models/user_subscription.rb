class UserSubscription < ActiveRecord::Base
  belongs_to :user
  validates_uniqueness_of :user_id, scope: %i[subscribed_to subscribed_to_id]
end
