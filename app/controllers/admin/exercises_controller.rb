class Admin::ExercisesController < Admin::BaseController
  def index
    @exercises = exercises
  end

  def new
    @exercise = exercises.new
  end

  def create
    @exercise = exercises.new(exercise_params)
    if @exercise.save
      redirect_to edit_admin_exercise_path(@exercise)
    else
      render :new
    end
  end

  def edit
    @exercise = find_exercise
  end

  def update
    @exercise = find_exercise
    if @exercise.update_attributes(exercise_params)
      redirect_to admin_exercises_path, notice: t('.notice')
    else
      render :edit
    end
  end

  private

  def exercise_params
    params.require(:exercise).permit(:title, :summary, :intro, :instructions)
  end

  def find_exercise
    exercises.find(params[:id])
  end

  def exercises
    dependencies[:exercises]
  end
end
