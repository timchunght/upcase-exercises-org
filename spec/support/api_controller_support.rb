shared_examples_for "API Controller" do
  controller described_class do
    def auth_test
      render nothing: true
    end
  end

  it "rejects an authorized request" do
    controller_path = described_class.controller_path
    routes.draw { get "auth_test" => controller_path }

    get :auth_test

    expect(controller).to respond_with(401)
  end

  def authenticate(username=ENV["API_USERNAME"], password=ENV["API_PASSWORD"])
    request.env["HTTP_AUTHORIZATION"] =
      ActionController::HttpAuthentication::Basic.encode_credentials(
        username,
        password
      )
  end
end
