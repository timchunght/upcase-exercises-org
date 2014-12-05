class Api::BaseController < ApplicationController
  skip_before_filter :authorize, :verify_authenticity_token

  http_basic_authenticate_with(
    name: ENV["API_USERNAME"],
    password: ENV["API_PASSWORD"]
  )
end
