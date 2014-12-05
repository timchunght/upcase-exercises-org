require "spec_helper"

describe UrlHelper do
  include Rails.application.routes.url_helpers

  it "delegates to Rails.applications.routes.url_helpers" do
    expected_url = root_path

    url_helper = UrlHelper.new(host: "example.com")
    result = url_helper.root_path

    expect(result).to eq(expected_url)
  end

  describe "#url_for" do
    it "adds the host" do
      exercise = build_stubbed(:exercise)
      path = exercise_url(exercise, only_path: true)
      expected_url = "http://example.com#{path}"

      url_helper = UrlHelper.new(host: "example.com")
      result = url_helper.exercise_path(exercise, only_path: false)

      expect(result).to eq(expected_url)
    end
  end
end
