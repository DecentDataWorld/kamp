json.array!(@user_types) do |user_type|
  json.extract! user_type, :id, :user_type
  json.url user_type_url(user_type, format: :json)
end
