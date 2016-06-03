# Use this hook to configure devise mailer, warden hooks and so forth.
# Many of these configuration options can be set straight in your model.
Devise.setup do |config|

  # ==> ORM configuration
  # Load and configure the ORM. Supports :active_record (default) and
  # :mongoid (bson_ext recommended) by default. Other ORMs may be
  # available as additional gems.
  require 'devise/orm/active_record'

  # The default HTTP method used to sign out a resource. Default is :delete.
  config.sign_out_via = :delete

  config.omniauth :google_oauth2, ENV['GOOGLE_API_KEY'], ENV["GOOGLE_API_SECRET"]

end
