module Tilt
  class GitHubFlavoredMarkdown < Template
    def prepare
      @output = nil
    end

    def evaluate(scope, locals, &block)
      @output ||= GitHub::Markdown.render_gfm(data)
    end
  end

  register GitHubFlavoredMarkdown, 'markdown', 'mkd', 'md'
end
