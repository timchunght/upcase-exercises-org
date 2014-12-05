class DashboardsController < ApplicationController
  def show
    redirect_to URI.join(UPCASE_URL, "dashboard").to_s
  end
end
