class OauthCallbacksController < ApplicationController
  include ::NewRelic::Agent::MethodTracer

  skip_before_filter :authorize

  def show
    @user = authenticate
    if @user.subscriber?
      sign_in @user
      redirect_back_or default_after_auth_url
    else
      redirect_to "https://upcase.com/subscribe"
    end
  end

  private

  def authenticate
    dependencies[:authenticator_factory].new(auth_hash: auth_hash).authenticate
  end

  def default_after_auth_url
    if @user.admin?
      admin_root_url
    else
      root_url
    end
  end

  def auth_hash
    request.env['omniauth.auth']
  end

  add_method_tracer :authenticate
  add_method_tracer :show
end
