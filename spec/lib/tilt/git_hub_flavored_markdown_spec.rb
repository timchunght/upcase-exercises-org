require 'spec_helper'
require 'tilt/git_hub_flavored_markdown'

describe Tilt::GitHubFlavoredMarkdown do
  describe '#render' do
    it 'renders markdown files' do
      template = Tilt::GitHubFlavoredMarkdown.new { |t| '# Hello' }

      result = template.render

      expect(result).to eq("<h1>Hello</h1>\n")
    end
  end

  %w(md mkd markdown).each do |format|
    it "registers itself with tilt for .#{format} file" do
      expect(Tilt.mappings['md']).to include(Tilt::GitHubFlavoredMarkdown)
    end
  end
end
