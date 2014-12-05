require 'spec_helper'

describe 'comments/_comment.html' do
  it "renders the user's avatar" do
    user = build_stubbed(:user, username: 'example_user')
    comment = build_stubbed(:comment, user: user)
    stub_template '_avatar.html.haml' => 'rendered avatar'

    render comment

    expect(rendered).to include('rendered avatar')
  end

  it 'describes when the comment was created' do
    Timecop.freeze Time.now do
      comment = build_stubbed(:comment, created_at: 5.minutes.ago)

      render comment

      expect(rendered_words).to include('5 minutes ago')
    end
  end

  context 'when top level' do
    it_behaves_like :markdown_enabled_view do
      def render_markdown(markdown)
        comment = build_stubbed(:comment, text: markdown)
        allow(comment).to receive(:top_level?).and_return(true)

        render comment
      end
    end
  end

  context 'when inline' do
    it_behaves_like :markdown_enabled_view do
      def render_markdown(markdown)
        comment = build_stubbed(:comment, text: markdown)
        allow(comment).to receive(:top_level?).and_return(false)

        render comment
      end
    end
  end

  def rendered_words
    Capybara.string(rendered).text.split(/\s+/).join(' ')
  end
end
