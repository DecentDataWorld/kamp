json.array!(@activities) do |activity|
  json.extract! activity, :id, :name, :url, :description
  json.url activity_url(activity, format: :json)
end
