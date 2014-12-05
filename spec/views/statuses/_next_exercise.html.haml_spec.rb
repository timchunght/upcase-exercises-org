require 'spec_helper'

describe 'statuses/_next_exercise.html.haml' do
  it 'includes a link to the app root' do
    render

    expect(rendered).to have_css("a[href='#{root_path}']")
  end
end
