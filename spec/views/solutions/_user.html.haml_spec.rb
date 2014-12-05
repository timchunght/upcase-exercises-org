require 'spec_helper'

describe 'solutions/_user.html' do
  it "renders the user's avatar" do
    user = build_stubbed(:user, username: 'example_user')
    stub_template '_avatar.html.haml' => 'rendered avatar'

    render 'solutions/user', user: user, current_user: user

    expect(rendered).to include('rendered avatar')
  end
end
