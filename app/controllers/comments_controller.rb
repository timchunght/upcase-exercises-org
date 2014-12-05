class CommentsController < ApplicationController
  layout false

  def new
    @comment = solution.comments.new(new_params)
  end

  def create
    @comment = feedback.create_comment(comment_params)
  end

  private

  def feedback
    dependencies[:feedback_factory].new(
      exercise: solution.exercise,
      reviewer: current_user,
      revision: solution.latest_revision,
      viewed_solution: solution
    )
  end

  def solution
    Solution.find(params[:solution_id])
  end

  def comment_params
    params.require(:comment).permit(:text, :location).merge(user: current_user)
  end

  def new_params
    params.permit(:solution_id, :location)
  end
end
