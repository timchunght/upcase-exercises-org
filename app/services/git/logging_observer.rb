module Git
  class LoggingObserver
    pattr_initialize :logger

    def clone_created(exercise, user, sha)
      logger.info "Cloned #{exercise.title} for #{user.username} at #{sha}"
    end

    def diff_fetched(clone, diff)
      logger.info(
        "Fetched diff for #{clone.username}/#{clone.title} " \
        "(#{diff.size} bytes)"
      )
    end
  end
end
