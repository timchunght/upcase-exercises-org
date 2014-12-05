require "spec_helper"

describe "solutions/_file.html.haml" do
  it "preserves whitespace" do
    input = <<-EOS.strip_heredoc
      class Example
        def one
        end

        def two
        end
      end
    EOS

    render_contents input

    expect(rendered_text).to eq(input)
  end

  it "highlights changed lines" do
    render_lines([
     unchanged( "class Example" ),
     changed(   "  def one"     ),
     changed(   "  end"         ),
     unchanged( ""              ),
     unchanged( "  def two"     ),
     unchanged( "  end"         ),
     unchanged( "end"           )
    ])

    expect(added_text.strip_heredoc).to eq(<<-TEXT.strip_heredoc)
      def one
      end
    TEXT
  end

  it "marks blank lines" do
    input = <<-EOS.strip_heredoc
      one

      two

      three
    EOS

    render_contents input

    expect(blank_lines.length).to eq(2)
  end

  it "escapes markup "do
    input = "<p>Hello</p>"

    render_contents input

    expect(rendered_text.strip).to eq(input)
  end

  it "adds location metadata to files" do
    render_file do |file|
      allow(file).to receive(:location_template).and_return("123:file:?")
    end

    expect(rendered).to have_css("[data-role=file][data-location='123:file:?']")
  end

  def render_contents(contents)
    lines = contents.each_line.map { |text| unchanged(text.rstrip) }
    render_lines lines
  end

  def render_lines(lines)
    render_file do |file|
      yield_each(allow(file).to(receive(:each_line)), lines)
    end
  end

  def render_file
    solution = double("solution")
    file = double("file", name: "example.txt", location_template: "?")
    comment_locator = double("comment_locator", inline_comments_for: [])
    allow(file).to receive(:each_line)
    yield file

    render(
      "solutions/file",
      file: file,
      solution: solution,
      comment_locator: comment_locator
    )
  end

  def yield_each(starting_stub, enumerable)
    enumerable.inject(starting_stub) { |stub, item| stub.and_yield(item) }
  end

  def changed(text)
    line(text, true)
  end

  def unchanged(text)
    line(text, false)
  end

  def line(text, changed)
    double(
      "line: #{text}",
      text: text,
      changed?: changed,
      blank?: text.blank?,
      number: 1,
      comments: [],
    )
  end

  def rendered_text
    lines("code")
  end

  def added_text
    lines(".comments code")
  end

  def blank_lines
    lines(".blank code")
  end

  def lines(selector)
    Capybara.string(rendered).all(selector).map { |node| "#{node.text}\n" }.join
  end
end
