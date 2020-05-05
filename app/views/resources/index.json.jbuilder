json.array!(@resources) do |resource|
  json.extract! resource, :id, :url, :name, :description, :format, :collection_id, :status, :resource_type
  json.url resource_url(resource, format: :json)
end
