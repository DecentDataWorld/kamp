json.array!(@banners) do |banner|
  json.extract! banner, :id, :visible, :heading, :intro_text, :col1_heading, :col1_body, :col2_heading, :col2_body, :footnote, :banner_type
  json.url banner_url(banner, format: :json)
end
