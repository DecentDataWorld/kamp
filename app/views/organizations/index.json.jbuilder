json.array!(@organizations) do |organization|
  json.extract! organization, :id, :url, :name, :description, :status
  json.url organization_url(organization, format: :json)
end
