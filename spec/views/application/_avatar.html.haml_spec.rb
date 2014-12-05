require 'spec_helper'

describe 'application/_avatar.html.haml' do
  it "renders the user's avatar" do
    user = build_stubbed(:user, avatar_url: 'http://foo.com')

    render 'avatar', user: user

    image = Capybara.string(rendered).find("img")
    expect(image["alt"]).to eq(user.username)
    expect(image["src"]).to eq("#{user.avatar_url}?s=24")
    expect(image["title"]).to eq(user.username)
  end
end
