require 'spec_helper'

describe 'exercises/_intro.html' do
  it_behaves_like :markdown_enabled_view do
    def render_markdown(markdown)
      exercise = build_stubbed(:exercise, intro: markdown)
      render template: 'exercises/_intro', locals: { exercise: exercise }
    end
  end
end
