json.array!(@licenses) do |license|
  json.extract! license, :id, :name
  json.url license_url(license, format: :json)
end
