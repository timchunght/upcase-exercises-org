require 'spec_helper'

describe "exercises/_instructions.html" do
  it_behaves_like :markdown_enabled_view do
    def render_markdown(markdown)
      exercise = build_stubbed(:exercise, instructions: markdown)
      repository = build(:repository)
      clone = double("clone", repository: repository, exercise: exercise)
      render(
        template: "exercises/_instructions",
        locals: { exercise: exercise, clone: clone }
      )
    end
  end
end
