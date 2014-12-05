require "omniauth-oauth2"
require "new_relic/agent/method_tracer"
require "new_relic/agent/instrumentation/controller_instrumentation"

module OmniAuth
  module Strategies
    class Upcase < OmniAuth::Strategies::OAuth2
      include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation
      include ::NewRelic::Agent::MethodTracer

      option :name, "upcase"

      option :client_options, site: UPCASE_URL, authorize_url: "/oauth/authorize"

      uid { raw_info["id"] }
      info { raw_info.except("id") }
      extra { { "raw_info" => raw_info } }

      def raw_info
        @raw_info ||= fetch_raw_info.parsed["user"]
      end

      private

      def fetch_raw_info
        access_token.get("/api/v1/me.json")
      end

      add_method_tracer :fetch_raw_info
      add_transaction_tracer :callback_call, category: :rack, name: "callback"
      add_transaction_tracer :request_call, category: :rack, name: "request"
    end
  end
end
