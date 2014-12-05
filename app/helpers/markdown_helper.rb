module MarkdownHelper
  def html_escaped_markdown(text)
    Tilt["markdown"].new { html_escape(text) }.render.strip.html_safe
  end
end
