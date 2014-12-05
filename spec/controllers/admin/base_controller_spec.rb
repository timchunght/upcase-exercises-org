require 'spec_helper'

describe Admin::BaseController do
  controller do
    def index
      render nothing: true
    end
  end

  context 'as an admin' do
    it 'allows access' do
      sign_in_as create(:admin)

      get :index

      should respond_with(:success)
    end
  end

  context 'as a subscriber' do
    it 'denies access' do
      sign_in_as create(:subscriber)

      get :index

      should deny_access
    end
  end
end
