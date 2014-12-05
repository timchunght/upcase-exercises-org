namespace :pusher do
  desc "Runs a fake Pusher endpoint using pusher-fake"
  task fake: :environment do
    PusherFake.configuration.tap do |config|
      config.socket_options[:port] = 8080
      config.web_options[:port] = 8081
      Pusher.host = config.web_options[:host]
      Pusher.port = config.web_options[:port]
    end

    PusherFake::Server.start
  end
end
