# Use different ports than development server
PusherFake.configuration.tap do |config|
  config.socket_options[:port] = 8090
  config.web_options[:port] = 8091
end

require "pusher-fake/support/base"
