Clearance.configure do |config|
  config.cookie_expiration = lambda { |_| nil }
  config.mailer_sender = "help@upcase.com"
end
