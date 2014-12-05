module Upcase
  class ExerciseObserver
    pattr_initialize [:upcase_client!, :url_helper!]

    def saved(exercise)
      upcase_client.synchronize_exercise(
        edit_url: url_helper.edit_admin_exercise_url(exercise),
        summary: exercise.summary,
        title: exercise.title,
        url: url_helper.exercise_url(exercise),
        uuid: exercise.uuid
      )
    end

    def created(_exercise)
    end

    def updated(_exercise)
    end
  end
end
