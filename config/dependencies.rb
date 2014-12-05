factory :authenticator_factory do |container|
  Authenticator.new(container[:auth_hash])
end

service :git_server do |container|
  Git::BackgroundServer.new(
    container[:immediate_git_server],
    container[:git_server_job_factory]
  )
end

service :immediate_git_server do |container|
  Gitolite::Server.new(
    config_committer: container[:config_committer],
    observer: container[:git_observer],
    repository_finder: container[:repository_finder]
  )
end

factory :git_server_job_factory do |container|
  container[:queue].enqueue(
    Git::ServerJob.new(
      method_name: container[:method_name],
      data: container[:data],
    )
  )
end

service :git_observer do |container|
  CompositeObserver.new([
    Git::CloneObserver.new(clones: container[:clones]),
    Git::LoggingObserver.new(
      container[:prefixed_logger_factory].new(prefix: "GIT: ")
    ),
    Git::PusherObserver.new(container[:user_channel_factory])
  ])
end

service :clones do |container|
  Clone.all
end

service :queue do |container|
  Delayed::Job
end

service :config_committer do |container|
  public_keys =
    container[:gitolite_public_key_query].new(relation: Gitolite::PublicKey.all)

  Gitolite::PublicKeyTrackingCommitter.new(
    Gitolite::ConfigCommitter.new(
      repository_factory: container[:repository_factory],
      config_writer: Gitolite::ConfigWriter.new(
        public_keys: public_keys,
        server_key: ENV["PUBLIC_KEY"],
        sources: container[:sources]
      )
    ),
    public_keys: public_keys
  )
end

factory :gitolite_public_key_query do |container|
  Gitolite::PublicKeyQuery.new(
    relation: container[:relation],
    observer: Gitolite::PusherObserver.new(container[:user_channel_factory])
  )
end

service :sources do |container|
  Gitolite::SourceCollection.new(
    container[:exercises],
    container[:repository_finder]
 )
end

service :exercises do |container|
  Exercise.alphabetical
end

decorate :exercises do |exercises, container|
  Gitolite::ReloadingCollection.new(exercises)
end

decorate :exercises do |exercises, container|
  DecoratingRelation.new(exercises, :exercise, container[:git_exercise_factory])
end

decorate :exercises do |exercises, container|
  DecoratingRelation.new(
    exercises,
    :exercise,
    container[:git_observed_exercise_factory]
  )
end

decorate :exercises do |exercises, container|
  DecoratingRelation.new(
    exercises,
    :exercise,
    container[:upcase_observed_exercise_factory]
  )
end

factory :git_observed_exercise_factory do |container|
  ObservableRecord.new(
    container[:exercise],
    Git::ExerciseObserver.new(container[:git_server])
  )
end

factory :git_exercise_factory do |container|
  Git::Exercise.new(container[:exercise], container[:git_server])
end

factory :upcase_observed_exercise_factory do |container|
  ObservableRecord.new(
    container[:exercise],
    container[:upcase_exercise_observer].new
  )
end

factory :upcase_exercise_observer do |container|
  Upcase::ExerciseObserver.new(
    upcase_client: container[:upcase_client],
    url_helper: container[:url_helper]
  )
end

service :shell do |container|
  ENV["SHELL_CLASS"].constantize.new
end

decorate :shell do |shell, container|
  Gitolite::IdentifiedShell.new(shell, ENV["IDENTITY"])
end

factory :participation_factory do |container|
  Participation.new(
    clones: CloneQuery.new(
      DecoratingRelation.new(
        container[:exercise].clones,
        :clone,
        container[:git_clone_factory]
      )
    ),
    exercise: container[:exercise],
    git_server: container[:git_server],
    user: container[:user]
  )
end

factory :git_clone_factory do |container|
  Git::Clone.new(container[:clone], container[:git_server])
end

factory :repository_factory do |container|
  Git::Repository.new(
    host: ENV["GIT_SERVER_HOST"],
    dsa_fingerprint: ENV["GIT_SERVER_DSA_FINGERPRINT"],
    rsa_fingerprint: ENV["GIT_SERVER_RSA_FINGERPRINT"],
    ecdsa_fingerprint: ENV["GIT_SERVER_ECDSA_FINGERPRINT"],
    path: container[:path]
  )
end

service :repository_finder do |container|
  Gitolite::RepositoryFinder.new(container[:repository_factory])
end

decorate :repository_factory do |component, container|
  Gitolite::ClonableRepository.new(component, container[:shell])
end

decorate :repository_factory do |component, container|
  Gitolite::ForkableRepository.new(component, container[:shell])
end

decorate :repository_factory do |component, container|
  Gitolite::CommittableRepository.new(component, container[:shell])
end

decorate :repository_factory do |component, container|
  Gitolite::RepositoryWithHistory.new(component, container[:shell])
end

decorate :repository_factory do |component, container|
  Gitolite::DiffableRepository.new(component, container[:shell])
end

factory :review_factory do |container|
  solutions = container[:reviewable_solutions_factory].new(
    solutions: container[:exercise].solutions
  )
  status = container[:status_factory].new(solutions: solutions)

  Review.new(
    exercise: container[:exercise],
    feedback: container[:feedback_factory].new,
    progress: container[:progressing_user_factory].new(solutions: solutions),
    solutions: solutions,
    status: status,
  )
end

factory :feedback_factory do |container|
  comment_locator = container[:comment_locator_factory].new(
    comments: container[:viewed_solution].comments
  )

  revision = container[:git_revision_factory].new(
    comment_locator: comment_locator
  )

  Feedback.new(
    comment_locator: comment_locator,
    viewed_revision: revision,
    revisions: DecoratingRelation.new(
      ChronologicalQuery.new(container[:viewed_solution].revisions),
      :base_revision,
      container[:numbered_revision_factory]
    ),
    comments: container[:viewed_solution].comments
  )
end

decorate :feedback_factory do |feedback, container|
  ObservingFeedback.new(
    feedback,
    CompositeObserver.new([
      container[:event_tracker_factory].new(user: container[:reviewer]),
      container[:comment_notifier_factory].new,
      container[:status_updater_factory].new(user: container[:reviewer]),
      container[:subscription_observer_factory].new
    ])
  )
end

factory :comment_notifier_factory do |container|
  container[:rescuing_observer_factory].new(
    observer: CommentNotifier.new(container[:comment_notification_factory])
  )
end

factory :numbered_revision_factory do |container|
  NumberedRevision.new(
    container[:base_revision],
    container[:viewed_solution].revisions
  )
end

factory :git_revision_factory do |container|
  Git::Revision.new(
    container[:revision],
    container[:diff_parser_factory]
  )
end

factory :status_factory do |container|
  Status::Finder.new([
    Status::AllStepsCompleted.new(
      progressing_user: container[:progressing_user_factory].new,
      reviewer: container[:solutions].solution_reviewer
    ),
    Status::AwaitingReview.new(container[:progressing_user_factory].new),
    Status::ReviewingOtherSolution.new(container[:solutions]),
    Status::SubmittedSolution.new(container[:solutions]),
    Status::NoSolution.new
  ]).find
end

factory :progressing_user_factory do |container|
  ProgressingUser.new(
    exercise: container[:exercise],
    user: container[:current_user],
    submitted_solution: container[:submitted_solution]
  )
end

factory :diff_parser_factory do |container|
  Git::DiffParser.new(container[:diff], container[:diff_file_factory])
end

factory :diff_file_factory do |container|
  Git::DiffFile.new(
    container[:diff_line_factory],
    ENV.fetch("MAX_DIFF_LINES").to_i
  )
end

decorate :diff_file_factory do |file, container|
  CommentableFile.new(
    file,
    container[:comment_locator]
  )
end

factory :diff_line_factory do |container|
  Git::DiffLine.new(
    text: container[:text],
    changed: container[:changed],
    file_name: container[:file_name],
    number: container[:number]
  )
end

factory :comment_locator_factory do |container|
  CommentLocator.new(
    revision: container[:revision],
    comments: ChronologicalQuery.new(container[:comments])
  )
end

factory :prioritized_solutions_factory do |container|
  PrioritizedSolutionQuery.new(container[:solutions].includes(:exercise, :user))
end

decorate :prioritized_solutions_factory do |solutions, _container|
  MemoizedEnumerable.new(solutions)
end

service :unreviewed_solutions do |container|
  container[:prioritized_solutions_factory].new(
    solutions: Solution.limit(50)
  )
end

service :latest_solutions do |_container|
  Solution.order(created_at: :desc).includes(:exercise, :user).limit(50)
end

factory :reviewable_solutions_factory do |container|
  ReviewableSolutionsQuery.new(
    solutions: container[:prioritized_solutions_factory].new,
    submitted_solution: container[:submitted_solution],
    viewed_solution: container[:viewed_solution],
  )
end

decorate :diff_line_factory do |diff_line, container|
  CommentableLine.new(
    diff_line,
    container[:comment_locator]
  )
end

factory :prefixed_logger_factory do |container|
  PrefixedLogger.new(container[:logger], container[:prefix])
end

service :logger do |container|
  Rails.logger
end

service :error_notifier do |container|
  if Rails.env.development? || Rails.env.test?
    ErrorReraiser.new
  else
    Airbrake
  end
end

service :mailer do |container|
  Mailer
end

decorate :mailer do |mailer, container|
  DelayedMailer.new(mailer)
end

factory :comment_notification_factory do |container|
  container[:mailer].comment(
    author: container[:comment].user,
    comment: container[:comment],
    recipient: container[:recipient],
    exercise: container[:comment].exercise,
    submitter: container[:comment].solution_submitter,
  )
end

decorate :comment_notification_factory do |message, container|
  FilteredMessage.new(
    message,
    filter: container[:comment].user,
    recipient: container[:recipient]
  )
end

service :current_public_keys do |container|
  container[:current_user].public_keys
end

decorate :current_public_keys do |public_keys, container|
  Gitolite::FingerprintedPublicKeyCollection.new(
    public_keys,
    container[:fingerprinter]
  )
end

service :fingerprinter do |container|
  Gitolite::Fingerprinter.new(container[:shell])
end

service :current_user do |container|
  container[:clearance_session].current_user
end

service :request do |container|
  ActionDispatch::Request.new(container[:rack_env])
end

service :requested_exercise do |container|
  params = container[:request]
  exercise_id = params[:exercise_id] || params[:id]
  Exercise.find(exercise_id)
end

service :current_participation do |container|
  container[:participation_factory].new(
    exercise: container[:requested_exercise],
    user: container[:current_user]
  )
end

service :current_overview do |container|
  container[:overview_factory].new(
    exercise: container[:requested_exercise],
    participation: container[:current_participation],
    user: container[:current_user]
  )
end

factory :overview_factory do |container|
  latest_revision = container[:participation].latest_revision

  submitted_solution = container[:participation].solution

  solutions = container[:reviewable_solutions_factory].new(
    solutions: container[:exercise].solutions,
    submitted_solution: submitted_solution,
    viewed_solution: nil
  )

  revision = latest_revision.fmap do |instance|
    container[:git_revision_factory].new(
      comment_locator: container[:comment_locator_factory].new(
        comments: Comment.none,
        revision: instance
      ),
      revision: instance,
    )
  end

  Overview.new(
    channel: container[:user_channel_factory].new(
      user_id: container[:user].id
    ),
    exercise: container[:exercise],
    participation: container[:participation],
    progress: container[:progressing_user_factory].new(
      solutions: solutions,
      submitted_solution: submitted_solution
    ),
    revision: revision,
    solutions: solutions,
    status: container[:status_factory].new(
      solutions: solutions,
      submitted_solution: submitted_solution
    ),
    user: container[:gitolite_user]
  )
end

service :gitolite_user do |container|
  Gitolite::User.new(
    container[:user],
    public_keys: container[:gitolite_public_key_query].new(
      relation: container[:user].public_keys
    )
  )
end

factory :user_channel_factory do |container|
  UserChannel.new(
    pusher: Pusher,
    user_id: container[:user_id]
  )
end

service :clearance_session do |container|
  container[:rack_env][:clearance]
end

factory :event_tracker_factory do |container|
  container[:rescuing_observer_factory].new(
    observer: EventTracker.new(
      container[:user],
      container[:exercise],
      container[:analytics_backend]
    )
  )
end

factory :status_updater_factory do |container|
  container[:rescuing_observer_factory].new(
    observer: StatusUpdater.new(
      exercise: container[:exercise],
      user: container[:user],
      upcase_client: container[:upcase_client]
    )
  )
end

service :analytics_backend do |container|
  if ENV["SEGMENT_IO_KEY"].present?
    Segment::Analytics.new(write_key: ENV["SEGMENT_IO_KEY"])
  else
    FakeAnalyticsBackend.new
  end
end

service :oauth_upcase_client do |container|
  OAuth2::Client.new(
    ENV['UPCASE_CLIENT_ID'],
    ENV['UPCASE_CLIENT_SECRET'],
    site: ENV['UPCASE_URL']
  )
end

service :upcase_client do |container|
  UpcaseClient.new(
    container[:oauth_upcase_client],
    error_notifier: container[:error_notifier]
  )
end

decorate :participation_factory do |participation, container|
  ObservingParticipation.new(
    participation,
    CompositeObserver.new([
      container[:event_tracker_factory].new,
      container[:status_updater_factory].new,
      container[:subscription_observer_factory].new
    ])
  )
end

factory :subscription_observer_factory do |container|
  SubscriptionObserver.new(container[:current_user])
end

service :url_helper do
  UrlHelper.new(host: ENV["APP_DOMAIN"])
end

factory :rescuing_observer_factory do |container|
  RescuingObserver.new(
    container[:observer],
    error_notifier: container[:error_notifier]
  )
end
