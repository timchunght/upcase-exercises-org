require 'spec_helper'

describe DashboardsController do
  describe "#show" do
    it "redirects to the Upcase dashboard" do
      stub_const "UPCASE_URL", "http://www.upcase.com"

      sign_in
      get :show

      should redirect_to("http://www.upcase.com/dashboard")
    end
  end
end
