require "spec_helper"

feature "Upcase admin signs in" do
  scenario "and becomes local admin" do
    FakeUpcase.sign_in "admin" => true
    visit admin_root_url
    click_on "Authorize"
    expect(page).to have_translation("admin.dashboards.show.exercises")
  end
end
