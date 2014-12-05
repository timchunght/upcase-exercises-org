class Admin::BaseController < ApplicationController
  before_filter :verify_admin
  layout 'admin'

  private

  def verify_admin
    unless current_user.admin?
      deny_access
    end
  end
end
