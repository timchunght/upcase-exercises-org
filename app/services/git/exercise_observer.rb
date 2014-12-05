module Git
  class ExerciseObserver
    pattr_initialize :server

    def created(exercise)
      server.create_exercise(exercise.slug)
    end

    def updated(_exercise)
    end

    def saved(_exercise)
    end
  end
end
