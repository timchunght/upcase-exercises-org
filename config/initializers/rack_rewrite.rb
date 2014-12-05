if Rails.env.staging? || Rails.env.production?
  require "rack/rewrite"

  Rails.configuration.middleware.insert_before(Rack::Runtime, Rack::Rewrite) do
    r301(
      %r{.*},
      "http://#{ENV["APP_DOMAIN"]}$&",
      if: -> (rack_env) { rack_env["SERVER_NAME"] != ENV["APP_DOMAIN"] }
    )
  end
end
