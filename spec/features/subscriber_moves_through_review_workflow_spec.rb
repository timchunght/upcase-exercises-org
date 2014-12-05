require "spec_helper"

feature "subscriber moves through review workflow" do
  scenario "and sees the correct prompts", js: true do
    exercise = create(:exercise)
    user = create(:user)
    workflow = start_exercise_workflow(exercise: exercise, user: user)

    second_user = create(:user)
    workflow.create_solution_by_other_user(user: second_user)
    workflow.create_solution_by_other_user

    workflow.preview_solution("example.txt")

    expect(page).to have_content("example.txt")
    expect(page).to have_content(
      I18n.t("solutions.statuses.ready_for_submission")
    )
    expect(page).not_to have_content("solutions.solution.assigned")

    workflow.click_top_submit

    expect_to_be_on_solution(exercise, second_user)
    expect(page).to have_content(
                      I18n.t("solutions.statuses.reviewing",
                      username: second_user.username)
                    )

    workflow.comment_on_solution
    workflow.click_continue

    expect_to_be_on_solution(exercise, user)
    expect(page).to have_content(I18n.t("solutions.statuses.awaiting_review"))

    comment = create_comment_on(solution_for(user))
    workflow.view_my_solution

    expect(page).to have_content(
      I18n.t("solutions.statuses.completed", username: comment.user.username)
    )
  end

  def solution_for(user)
    Solution.all.detect { |s| s.username == user.username }
  end

  def expect_to_be_on_solution(exercise, user)
    expect(current_path).to eq(exercise_solution_path(exercise, user))
  end

  def create_comment_on(solution)
    create(:comment, solution: solution)
  end
end
