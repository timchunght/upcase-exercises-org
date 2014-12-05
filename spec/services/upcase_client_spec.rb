require "spec_helper"

describe UpcaseClient do
  COMMON_ERRORS = [
    *HTTP_ERRORS.map(&:new),
    OAuth2::Error.new(OAuth2::Response.new(Faraday::Response.new))
  ]

  describe "#update_status" do
    COMMON_ERRORS.each do |error|
      it "notifies airbrake of trapped #{error}" do
        error_notifier = double("error_notifier", notify: nil)
        token = double
        allow(token).to receive(:post).and_raise(error)
        client = double(request: nil)
        user = build_stubbed(:user)
        allow(OAuth2::AccessToken).to receive(:new).and_return(token)
        upcase_client = build_upcase_client(
          client: client,
          error_notifier: error_notifier
        )

        upcase_client.update_status(user, "uuid", "state")

        expect(error_notifier).to have_received(:notify).with(
          error_class: error.class,
          error_message: "Error in UpcaseClient#update_status",
          parameters: {
            user_id: user.id,
            exercise_uuid: "uuid",
            state: "state",
            exception_message: error.message
          }
        )
      end
    end
  end

  describe "#synchronize_exercise" do
    let(:oauth_upcase_client) do
      OAuth2::Client.new(
        ENV["UPCASE_CLIENT_ID"],
        ENV["UPCASE_CLIENT_SECRET"],
        site: ENV["UPCASE_URL"]
      )
    end

    it "sends data with correct attributes" do
      attributes = {
        edit_url:
          "https://exercise.upcase.com/admin/exercises/refactoring/edit",
        summary: "Just make the code looks better!",
        title: "Refactoring",
        url: "https://exercise.upcase.com/exercises/refactoring",
        uuid: "UUID"
      }
      upcase_client = build_upcase_client(client: oauth_upcase_client)

      response = upcase_client.synchronize_exercise(attributes)
      expect(response.status).to eq 200

      json_response = JSON.parse(response.body)
      expect(json_response["edit_url"]).to eq attributes[:edit_url]
      expect(json_response["title"]).to eq attributes[:title]
      expect(json_response["url"]).to eq attributes[:url]
      expect(json_response["summary"]).to eq attributes[:summary]
      expect(json_response["uuid"]).to eq attributes[:uuid]
    end

    context "with invalid attributes" do
      it "notifies error service" do
        error_notifier = double("error_notifier", notify: nil)
        upcase_client = build_upcase_client(
          client: oauth_upcase_client,
          error_notifier: error_notifier
        )

        upcase_client.synchronize_exercise(uuid: "UUID", title: "")

        expect(error_notifier).to have_received(:notify)
      end
    end

    context "with other errors" do
      COMMON_ERRORS.each do |error|
        it "notifies airbrake of trapped #{error}" do
          attributes = {
            title: "Refactoring",
            url: "https://exercise.upcase.com/exercises/refactoring",
            summary: "Just make the code looks better!",
            uuid: "UUID"
          }
          error_notifier = double("error_notifier", notify: nil)
          client_credentials = client_credentials_fail_with(error)
          upcase_client = build_upcase_client(
            client: double(client_credentials: client_credentials),
            error_notifier: error_notifier
          )

          upcase_client.synchronize_exercise(attributes)

          expect(error_notifier).to have_received(:notify).with(
            error_class: error.class,
            error_message: "Error in UpcaseClient#synchronize_exercise",
            parameters: attributes.merge(exception_message: error.message)
          )
        end
      end
    end
  end

  def build_upcase_client(
    client:,
    error_notifier: double("error_notifier", notify: nil)
  )
    UpcaseClient.new(client, error_notifier: error_notifier)
  end

  def client_credentials_fail_with(error)
    token = double
    allow(token).to receive(:put).and_raise(error)
    double(get_token: token)
  end
end
