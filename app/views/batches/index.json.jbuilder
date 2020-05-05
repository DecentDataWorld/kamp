json.array!(@batches) do |batch|
  json.extract! batch, :id, :name, :uploader_id
  json.url batch_url(batch, format: :json)
end
