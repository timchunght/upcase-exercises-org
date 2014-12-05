require "sinatra/base"

class FakeUpcase < Sinatra::Base
  set :show_exceptions, false
  set :raise_errors, true

  UPCASE_DASHBOARD = "Upcase Dashboard"
  cattr_accessor :status_updates

  def self.sign_in(attributes = {})
    @@upcase_user = {
      "admin" => false,
      "avatar_url" => "https://gravat.ar/",
      "email" => "user@example.com",
      "first_name" => "Test",
      "has_active_subscription" => true,
      "id" => 1,
      "last_name" => "User",
      "public_keys" => ["ssh-rsa abcdefg"],
      "username" => "testuser"
    }.merge(attributes)
  end

  def self.initialize_status_updates
    @@status_updates = []
  end

  get "/oauth/authorize" do
    redirect_uri = URI.parse(params[:redirect_uri])
    state = params[:state]
    callback_url = redirect_uri.merge("?code=somecode&state=#{state}").to_s
    %{<a href="#{callback_url}">Authorize</a>}
  end

  post "/oauth/token" do
    content_type :json
    {
      "access_token" => "e72e16c7e42f292c6912e7710c838347ae178b4a",
      "token_type" => "bearer"
    }.to_json
  end

  get "/api/v1/me.json" do
    content_type :json
    { "user" => @@upcase_user }.to_json
  end

  get "/dashboard" do
    UPCASE_DASHBOARD
  end

  post "/api/v1/exercises/:exercise_uuid/status" do
    @@status_updates << {
      authorization_http_header: @env["HTTP_AUTHORIZATION"],
      exercise_uuid: params[:exercise_uuid],
      state: params[:state]
    }
    status 200
  end

  put "/api/v1/exercises/:exercise_uuid" do
    attributes = %w(title url summary)

    if attributes.all? { |attribute| params[:exercise][attribute].present? }
      status 200
      {
        id: 1,
        title: params[:exercise][:title],
        url: params[:exercise][:url],
        summary: params[:exercise][:summary],
        edit_url: params[:exercise][:edit_url],
        created_at: Time.current,
        updated_at: Time.current,
        uuid: params[:exercise_uuid]
      }.to_json
    else
      status 422
      missing_attributes = attributes - params[:exercise].keys
      {
        error: Hash[ missing_attributes.map { |attribute| [attribute, "can't be blank"] }
        ]
      }.to_json
    end
  end
end

class HostMap
  def initialize(mappings)
    @mappings = mappings
  end

  def call(env)
    app_for(env["SERVER_NAME"]).call(env)
  end

  private

  def app_for(server_name)
    @mappings[server_name] || NOT_FOUND
  end

  NOT_FOUND = lambda do |env|
    [
      404,
      { "Content-Type" => "text/html" },
      ["Unmapped server name: #{env["SERVER_NAME"]}"]
    ]
  end
end

WebMock.disable_net_connect!

RSpec.configure do |config|
  config.before do
    FakeUpcase.sign_in
    FakeUpcase.initialize_status_updates
    host_with_port = UPCASE_URL.split("//")[1]

    WebMock.
      stub_request(
        :any,
        %r{http:\/\/(\S+:\S+@)?#{Regexp.escape(host_with_port)}.*}
      ).
      to_rack(FakeUpcase)
  end
end

Capybara.app = HostMap.new(
  "www.example.com" => Capybara.app,
  "127.0.0.1" => Capybara.app,
  URI.parse(UPCASE_URL).host => FakeUpcase
)
