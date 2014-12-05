class UsernamesController < ApplicationController
  def update
    if current_user.update_attributes(user_attributes)
      redirect_to exercise_url(params[:exercise_id])
    else
      render :edit
    end
  end

  private

  def user_attributes
    params.require(:user).permit(:username)
  end
end
