require "spec_helper"

describe "solutions/_revision_history.html.haml" do
  it "contains a link to the current version of the solution" do
    user = build_stubbed(:user)
    exercise = build_stubbed(:exercise)
    revision = double(
      :revision,
      id: 1,
      exercise: exercise,
      user: user,
      number: 1,
      latest?: true,
      created_at: Time.now
    )
    feedback = double(
      :feedback,
      viewed_revision: revision,
      revisions: [revision],
    )
    solution_link = exercise_solution_path(exercise, user)

    render_revision_history_with(feedback)

    expect(rendered).to match(solution_link)
  end

  def render_revision_history_with(feedback)
    render("solutions/revision_history", feedback: feedback)
  end
end
