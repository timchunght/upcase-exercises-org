def expect_upcase_status_update(user, exercise, state)
  expect(FakeUpcase.status_updates.last).to eq({
    authorization_http_header: "Bearer #{user.auth_token}",
    exercise_uuid: exercise.uuid,
    state: state
  })
end
