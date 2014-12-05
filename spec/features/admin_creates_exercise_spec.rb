require 'spec_helper'

feature 'Admin creates exercise' do
  scenario 'with valid data' do
    visit_new_exercise_form
    fill_in 'Title', with: 'Shakespeare Analyzer'
    fill_in "exercise_summary", with: "Let's analyze Shakespeare's materials"
    fill_in 'exercise_intro', with: 'This is going to be a great exercise'
    fill_in(
      'exercise_instructions',
      with: 'As a Shakespeare buff, do this exercise'
    )
    click_button I18n.t('helpers.submit.exercise.create')

    expect(page).to have_content('Shakespeare Analyzer')
    expect(page).to have_git_url('shakespeare-analyzer')
  end

  scenario 'with invalid data' do
    visit_new_exercise_form
    click_button I18n.t('helpers.submit.exercise.create')

    expect(page).to have_content("can't be blank")
  end

  def visit_new_exercise_form
    sign_in_as_admin
    click_link I18n.t('admin.dashboards.show.exercises')
    click_link I18n.t('admin.exercises.index.create_exercise'), match: :first
  end

  def have_git_url(slug)
    have_content("sources/#{slug}")
  end
end
