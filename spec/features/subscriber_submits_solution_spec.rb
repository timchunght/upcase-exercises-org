require 'spec_helper'

feature 'subscriber submits solution', js: true do
  scenario "sees prompt to review another solution" do
    other_exercise = create(:exercise)
    other_user = create(:user, username: "otheruser")
    workflow = start_exercise_workflow
    workflow.create_solution_by_other_user(
      user: other_user,
      filename: "wrong_exercise.txt",
      exercise: other_exercise
    )
    workflow.create_solution_by_other_user(
      user: other_user,
      filename: "other_user.txt",
    )
    workflow.submit_solution
    click_on I18n.t("solutions.solution.assigned")

    expect(page).to have_content("other_user.txt")
  end

  scenario 'sees their own solution until another user submits one' do
    workflow = start_exercise_workflow(username: 'myuser')

    workflow.submit_solution('mysolution.txt')

    expect(page).to have_css(
      '.active',
      text: I18n.t('solutions.show.my_solution'),
    )
    expect(page).to have_no_solutions_heading
  end

  scenario "by clicking the button at the bottom of the page" do
    workflow = start_exercise_workflow
    workflow.create_solution_by_other_user(
      username: "otheruser",
      filename: "other_user.txt",
    )
    workflow.preview_solution
    workflow.click_bottom_submit

    expect(page).to have_content("other_user.txt")
  end

  def have_no_solutions_heading
    have_content(I18n.t('solutions.show.no_solutions_heading'))
  end
end
