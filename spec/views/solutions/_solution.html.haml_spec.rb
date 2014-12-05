require 'spec_helper'

describe 'solutions/_solution.html.haml' do
  context 'with an active solution' do
    it 'has the active css class' do
      solution = build_stubbed(:solution)
      render_solution(solution, viewed: solution)

      expect(rendered).to have_css('.active')
    end
  end

  context 'with an inactive solution' do
    it 'does not have the active css class' do
      solution = build_stubbed(:solution)
      other = build_stubbed(:solution)
      render_solution(solution, viewed: other)

      expect(rendered).not_to have_css('.active')
    end
  end

  context 'with an assigned solution' do
    it 'has the assigned css class and text' do
      solution = build_stubbed(:solution)
      render_solution(solution, assigned: solution)

      expect(rendered).to have_css('.assigned')
      expect(rendered).to have_text(t('solutions.solution.assigned'))
    end
  end

  context 'with an unassigned solution' do
    it 'does not have the assigned css class and text' do
      solution = build_stubbed(:solution)
      other = build_stubbed(:solution)
      render_solution(solution, assigned: other)

      expect(rendered).not_to have_css('.assigned')
      expect(rendered).not_to have_text(t('solutions.solution.assigned'))
    end
  end

  it 'links to the solution' do
    solution = build_stubbed(:solution)
    url = exercise_solution_url(solution.exercise, solution.user)

    render_solution(solution)

    expect(rendered).to have_css("a[href='#{url}']")
  end

  def render_solution(
    solution,
    viewed: build_stubbed(:solution),
    assigned: build_stubbed(:solution)
  )
    solutions = double(
      'solutions',
      assigned_solution: assigned,
      viewed_solution: viewed
    )
    stub_template 'solutions/_user.html.haml' => 'user details'
    render solution, solutions: solutions
  end
end
