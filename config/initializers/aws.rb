require 'json'

creds = Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])

Aws::Rails.add_action_mailer_delivery_method(
  :ses, # or :sesv2
  credentials: creds,
  region: 'us-east-1',
  # some other config
)