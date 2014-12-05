if defined?(PusherFake)
  PusherFake.configuration.tap do |config|
    config.socket_options[:port] = 8080
    config.web_options[:port] = 8081

    Pusher.app_id = config.app_id
    Pusher.host = config.web_options[:host]
    Pusher.key = config.key
    Pusher.port = config.web_options[:port]
    Pusher.secret = config.secret
  end
end
