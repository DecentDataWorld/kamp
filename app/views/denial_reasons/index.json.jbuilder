json.array!(@denial_reasons) do |denial_reason|
  json.extract! denial_reason, :id, :reason
  json.url denial_reason_url(denial_reason, format: :json)
end
