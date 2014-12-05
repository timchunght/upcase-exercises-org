require "spec_helper"

describe "exercises/_preview_my_solution" do
  context "before pushing" do
    it "disables the button to preview" do
      exercise = build_stubbed(:exercise)
      overview = double("overview", exercise: exercise, unpushed?: true)

      render "exercises/preview_my_solution", overview: overview

      button =
        page.find_button(I18n.t("exercises.show.no_commits"), disabled: true)
      expect(button).to be_present
    end
  end

  context "after pushing" do
    it "enables the button to preview" do
      exercise = build_stubbed(:exercise)
      overview = double("overview", exercise: exercise, unpushed?: false)

      render "exercises/preview_my_solution", overview: overview

      link = page.find_link(I18n.t("exercises.show.preview_my_solution"))
      expect(link).to be_present
    end
  end

  def page
    Capybara.string(rendered)
  end
end
