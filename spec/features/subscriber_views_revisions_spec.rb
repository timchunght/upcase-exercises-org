require "spec_helper"

feature "Subscriber views a revision" do
  FIRST_REVISION_TEXT = "first_revision"
  LAST_REVISION_TEXT = "fourth_revision"

  scenario "when it is an old revision", js: true do
    visit_revision

    expect(page).to have_content(FIRST_REVISION_TEXT)
    expect(page).not_to have_content(LAST_REVISION_TEXT)
  end

  def visit_revision(inline_comment = "hi", top_level_comment = "hi")
    workflow = start_exercise_workflow
    workflow.submit_solution(FIRST_REVISION_TEXT)
    workflow.push_to_clone("second_revision")
    workflow.push_to_clone("third_revision")
    workflow.push_to_clone(LAST_REVISION_TEXT)

    workflow.view_my_solution
    click_first_revision_link
  end

  def click_first_revision_link
    find(".revision-history ol li:first-child a").click
  end
end
