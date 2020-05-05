json.array!(@users_organizations) do |users_organization|
  json.extract! users_organization, :id, :organization_id, :user_id, :role
  json.url users_organization_url(users_organization, format: :json)
end
