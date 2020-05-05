json.array!(@user_subscriptions) do |user_subscription|
  json.extract! user_subscription, :id, :user_id, :subscribed_to, :subscribed_to_id
  json.url user_subscription_url(user_subscription, format: :json)
end
