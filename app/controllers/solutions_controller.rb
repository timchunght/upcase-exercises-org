class SolutionsController < ApplicationController
  def new
    @overview = dependencies[:current_overview]
  end

  def create
    participation.create_solution
    redirect_to(
      exercise_solution_path(
        exercise,
        solutions.assigned_solver
      )
    )
  end

  private

  def participation
    @participation ||= dependencies[:participation_factory].new(
      exercise: exercise,
      user: current_user
    )
  end

  def exercise
    @exercise ||= Exercise.find(params[:exercise_id])
  end

  def solution
    participation.solution
  end

  def solutions
    dependencies[:reviewable_solutions_factory].new(
      solutions: exercise.solutions,
      submitted_solution: solution,
      viewed_solution: solution
    )
  end
end
