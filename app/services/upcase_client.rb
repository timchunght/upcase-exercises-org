class UpcaseClient
  COMMON_ERRORS = [*HTTP_ERRORS, OAuth2::Error]

  pattr_initialize :oauth_upcase_client, [:error_notifier!]

  def update_status(user, exercise_uuid, state)
    access_token = OAuth2::AccessToken.new(oauth_upcase_client, user.auth_token)
    access_token.post(
      "/api/v1/exercises/#{exercise_uuid}/status",
      params: { state: state }
    )
  rescue *COMMON_ERRORS => exception
    notify_error(
      exception,
      :update_status,
      user_id: user.id,
      exercise_uuid: exercise_uuid,
      state: state,
    )
  end

  def synchronize_exercise(exercise_attributes)
    uuid = exercise_attributes[:uuid]
    access_token = oauth_upcase_client.client_credentials.get_token
    access_token.put(
      "/api/v1/exercises/#{uuid}",
      params: { exercise: exercise_attributes.except(:uuid) }
    )
  rescue *COMMON_ERRORS => exception
    notify_error(exception, :synchronize_exercise, exercise_attributes)
  end

  private

  def notify_error(exception, method_name, parameters)
    error_notifier.notify(
      error_class: exception.class,
      error_message: "Error in UpcaseClient##{method_name}",
      parameters: parameters.merge(exception_message: exception.message)
    )
  end
end
