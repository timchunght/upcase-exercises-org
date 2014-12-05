require "spec_helper"

describe "exercises/_navigation.html" do
  context "for a user with a solution" do
    it "links to the solutions and instructions" do
      exercise = build_stubbed(:exercise)
      assigned_solver = build_stubbed(:user)

      render_navigation(
        exercise: exercise,
        user_has_solution: true,
        assigned_solver: assigned_solver
      )

      expect(navigation).to have_content(exercise.title)
      expect(navigation).to have_link(exercise_path(exercise))
      expect(navigation).to have_link(
        exercise_solution_path(exercise, assigned_solver)
      )
    end
  end

  context "for a user without a solution" do
    it "doesn't link to solutions or instructions" do
      render_navigation(user_has_solution: false)

      expect(navigation).not_to have_css("a[href]")
    end
  end

  it "renders the exercise title" do
    exercise = build_stubbed(:exercise)

    render_navigation exercise: exercise

    expect(navigation).to have_content(exercise.title)
  end

  def render_navigation(exercise: build_stubbed(:exercise), **solutions_args)
    solutions = stub_solutions(**solutions_args)
    render "exercises/navigation", exercise: exercise, solutions: solutions
  end

  def stub_solutions(
    assigned_solver: build_stubbed(:user),
    user_has_solution: true
  )
    double(
      "solutions",
      assigned_solver: assigned_solver,
      user_has_solution?: user_has_solution
    )
  end

  def navigation
    @view_flow = view.view_flow
    Capybara.string(content_for(:navigation))
  end

  def have_link(url)
    have_css("a[href='#{url}']")
  end
end
