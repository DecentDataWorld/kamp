json.array!(@collections) do |collection|
  json.extract! collection, :id, :url, :title, :description, :status, :author_id, :maintainer_id, :type_id, :organization_id, :notes
  json.url collection_url(collection, format: :json)
end
