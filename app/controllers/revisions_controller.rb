class RevisionsController < ApplicationController
  def show
    if can_view_solution?
      @review = review
    else
      redirect_to exercise
    end
  end

  private

  def can_view_solution?
    admin_user? || solution_by_current_user.present?
  end

  def admin_user?
    current_user.admin?
  end

  def review
    dependencies[:review_factory].new(
      exercise: exercise,
      revision: revision,
      viewed_solution: solution,
      submitted_solution: solution_by_current_user,
      reviewer: current_user
    )
  end

  def participation_by_current_user
    participation_by(current_user)
  end

  def participation_by(user)
    dependencies[:participation_factory].new(
      exercise: exercise,
      user: user
    )
  end

  def solution_by_current_user
    participation_by_current_user.solution
  end

  def revision_by_number
    if params[:id]
      Revision.find_by_number(solution, params[:id])
    end
  end

  def latest_revision
    solution.latest_revision
  end

  def user
    @user = User.find(user_id)
  end

  def exercise
    @exercise ||= Exercise.find(params[:exercise_id])
  end

  def solution
    @solution ||= participation_by(user).solution.
      blank { raise ActiveRecord::RecordNotFound }.unwrap
  end

  def revision
    @revision ||= revision_by_number || latest_revision
  end

  def user_id
    params[:solution_id]
  end
end
