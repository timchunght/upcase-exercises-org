class ApplicationController < ActionController::Base
  include Clearance::Controller
  include Payload::Controller

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authorize

  private

  def url_after_denied_access_when_signed_out
    "/auth/upcase"
  end
end
