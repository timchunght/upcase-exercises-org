require 'spec_helper'

feature 'admin edits exercise' do
  scenario 'with valid data' do
    exercise = create(:exercise, title: 'Original title')

    visit_exercise exercise
    update_exercise_title 'New title'

    expect(page).to have_exercise_updated_notice
    expect(page).to have_content('New title')
    expect(page).not_to have_content('Original title')
  end

  scenario 'with invalid data' do
    exercise = create(:exercise, title: 'Original title')

    visit_exercise exercise
    update_exercise_title ''

    expect(page).to have_content("can't be blank")

    update_exercise_title 'New title'

    expect(page).to have_exercise_updated_notice
  end

  def visit_exercise(exercise)
    sign_in_as_admin
    click_on I18n.t('admin.dashboards.show.exercises')
    click_on exercise.title
  end

  def update_exercise_title(title)
    fill_in 'Title', with: title
    click_on I18n.t('admin.exercises.index.update_exercise')
  end

  def have_exercise_updated_notice
    have_content('Exercise updated')
  end
end
