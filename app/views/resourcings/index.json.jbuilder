json.array!(@resourcings) do |resourcing|
  json.extract! resourcing, :id, :resource_id, :resourceable_id, :resourceable_type
  json.url resourcing_url(resourcing, format: :json)
end
