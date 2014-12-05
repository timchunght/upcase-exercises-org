UPCASE_CLIENT_ID = ENV["UPCASE_CLIENT_ID"]
UPCASE_CLIENT_SECRET = ENV["UPCASE_CLIENT_SECRET"]
UPCASE_URL = ENV["UPCASE_URL"]

require "omniauth-upcase"

Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :upcase,
    UPCASE_CLIENT_ID,
    UPCASE_CLIENT_SECRET
  )
end

OmniAuth.config.logger = Rails.logger
