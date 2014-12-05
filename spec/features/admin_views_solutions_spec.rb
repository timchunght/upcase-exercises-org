require "spec_helper"

feature "admin views a solution" do
  scenario "and comments on it", js: true do
    exercise = create(:exercise)
    other_user = create(:user, username: "other_user")
    admin = create(:admin)
    workflow = start_exercise_workflow(
                 exercise: exercise,
                 user: admin,
               )
    workflow.create_solution_by_other_user(user: other_user)

    visit_solutions_for(exercise: exercise, as: admin)
    workflow.comment_on_solution("Looks good")
    reload_page

    expect(page).to have_content("Looks good")
    expect(page).to have_content(
      I18n.t("solutions.show.solution_for_user", username: "other_user")
    )
    expect(page).to have_content(I18n.t("solutions.show.no_solution"))
    expect(page).to have_content(I18n.t("solutions.statuses.no_solution"))
  end

  scenario "and sees list of all solutions" do
    solution1, solution2 = create_pair(:solution)
    visit_solutions
    expect_to_see_solution(solution1)
    expect_to_see_solution(solution2)
  end

  def visit_solutions_for(options)
    visit admin_root_path(as: options[:as])
    click_on I18n.t("admin.dashboards.show.exercises")
    click_on options[:exercise].title
    click_on "View Solutions"
  end

  def visit_solutions
    sign_in_as_admin
    click_on(I18n.t("admin.dashboards.show.solutions"))
  end

  def expect_to_see_solution(solution)
    expect(page).to have_content(solution.exercise.title)
    expect(page).to have_content(solution.user.username)
    expect(page).to have_content(solution.comments_count)
  end

  def reload_page
    visit current_path
  end
end
