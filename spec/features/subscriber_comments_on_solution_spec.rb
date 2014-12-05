require 'spec_helper'

feature 'subscriber comments on solution', js: true do
  scenario 'inline' do
    user = create(:user)
    exercise = create(:exercise)
    workflow = start_exercise_workflow(exercise: exercise, user: user)
    workflow.create_completed_solution(user)
    commenting_user = create(:user)
    workflow.create_completed_solution(commenting_user)
    visit exercise_solution_path(exercise, user, as: commenting_user)
    workflow.comment_on_solution_inline('Looks great')

    expect(page).to have_content('Looks great')
    expect_self_notification_to user.email, exercise.title
    expect_upcase_status_update commenting_user, exercise, "Complete"
  end

  scenario 'at the top level' do
    exercise = create(:exercise)
    user = create(:user)
    workflow = start_exercise_workflow(exercise: exercise, user: user)
    workflow.create_completed_solution(user)
    other_user = create(:user)
    workflow.create_completed_solution(other_user)

    visit exercise_solution_path(exercise, other_user, as: user)
    workflow.view_solution_by(other_user.username)
    workflow.comment_on_solution('Looks great!')

    expect(page).to have_content('Looks great!')
    expect_self_notification_to other_user.email, exercise.title
    expect_upcase_status_update user, exercise, "Complete"

    reset_mailer
    visit exercise_solution_path(exercise, other_user, as: other_user)
    workflow.comment_on_solution("Thanks!")

    expect_others_notification_to(
      user.email,
      other_user.username,
      exercise.title
    )
    expect_no_notification_to other_user.email
  end

  def expect_self_notification_to(email, exercise_title)
    message = open_last_email_for(email)
    expect(message).to have_subject(
      I18n.t("mailer.comment.subject.self", exercise: exercise_title)
    )
  end

  def expect_others_notification_to(email, submitter_username, exercise_title)
    message = open_last_email_for(email)
    expect(message).to have_subject(
      I18n.t(
        "mailer.comment.subject.others",
        exercise: exercise_title,
        username: submitter_username
      )
    )
  end

  def expect_no_notification_to(email)
    expect(find_email(email)).to be_nil
  end
end
