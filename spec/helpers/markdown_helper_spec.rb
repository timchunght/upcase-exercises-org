require "spec_helper"

describe MarkdownHelper do
  describe "#html_escaped_markdown" do
    it "returns sanitized rendered markdown content" do
      text = "<script> *Hello*"

      expect(helper.html_escaped_markdown(text)).
        to eq("<p>&lt;script&gt; <em>Hello</em></p>")
    end
  end
end
