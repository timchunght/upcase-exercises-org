require 'spec_helper'

feature 'User views exercise' do
  scenario 'with valid data' do
    user = create(:user)
    exercise = create(:exercise)

    visit exercise_path(exercise, as: user)

    expect(page).to have_content(exercise.title)
    expect(page).to have_content(exercise.intro)
    expect(page).to have_title(exercise.title)
  end
end
