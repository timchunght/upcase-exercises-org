require 'spec_helper'

describe Git::DiffParser do
  describe '#parse' do
    context 'with modified files' do
      it 'returns the files with new contents' do
        result = parse_diff(<<-DIFF)
          diff --git a/path/to/one.txt b/path/to/one.txt
          index 802f69c..22cbdfd 100644
          --- a/path/to/one.txt
          +++ b/path/to/one.txt
          @@ -1,3 +1,5 @@
           Line one
          +In between one and two
           Line two
           Line three
          +After three
          diff --git a/path/to/two.txt b/path/to/two.txt
          index fa5ca96..7151b36 100644
          --- a/path/to/two.txt
          +++ b/path/to/two.txt
          @@ -1,3 +1,3 @@
           ABC
          -DEF
          +DEF is the second line
           GHI
        DIFF

        expect(result).to eq(
          'path/to/one.txt' => [
            ' Line one',
            '+In between one and two',
            ' Line two',
            ' Line three',
            '+After three'
          ],
          'path/to/two.txt' => [
            ' ABC',
            '+DEF is the second line',
            ' GHI'
          ]
        )
      end
    end

    context 'without a newline at the end of the file' do
      it 'ignores the missing newline' do
        result = parse_diff(<<-DIFF)
          diff --git path/to/new.txt b/path/to/new.txt
          new file mode 100644
          index 0000000..8e1fbbd
          --- /dev/null
          +++ b/path/to/new.txt
          +New file
          \\ No newline at end of file
        DIFF

        expect(result).to eq(
          'path/to/new.txt' => [
            '+New file'
          ]
        )
      end
    end

    context 'with added files' do
      it 'returns the files with new contents' do
        result = parse_diff(<<-DIFF)
          diff --git path/to/new.txt b/path/to/new.txt
          new file mode 100644
          index 0000000..8e1fbbd
          --- /dev/null
          +++ b/path/to/new.txt
          +New file
        DIFF

        expect(result).to eq(
          'path/to/new.txt' => [
            '+New file'
          ]
        )
      end
    end

    context 'with deleted files' do
      it 'does not return deleted files' do
        result = parse_diff(<<-DIFF)
          diff --git a/path/to/changed.txt b/path/to/changed.txt
          index 802f69c..22cbdfd 100644
          --- a/path/to/changed.txt
          +++ b/path/to/changed.txt
          @@ -1,3 +1,5 @@
           Line one
          +In between one and two
           Line two
          diff --git a/path/to/deleted b/path/to/deleted
          deleted file mode 100644
          index 22cbdfd..0000000
          --- a/path/to/deleted
          +++ /dev/null
          @@ -1,5 +0,0 @@
          -Deleted file
        DIFF

        expect(result).to eq(
          'path/to/changed.txt' => [
            ' Line one',
            '+In between one and two',
            ' Line two'
          ]
        )
      end
    end

    context 'with changed file modes' do
      it 'returns only files with other changes' do
        result = parse_diff(<<-DIFF)
          diff --git a/path/to/changed.txt b/path/to/changed.txt
          old mode 100644
          new mode 100755
          index 22cbdfd..4bf5ca7
          --- a/path/to/changed.txt
          +++ b/path/to/changed.txt
          @@ -1,5 +1,6 @@
           Line one
          +In between one and two
           Line two
          diff --git a/path/to/mode.txt b/path/to/mode.txt
          old mode 100644
          new mode 100755
        DIFF

        expect(result).to eq(
          'path/to/changed.txt' => [
            ' Line one',
            '+In between one and two',
            ' Line two'
          ]
        )
      end
    end

    context "with a binary file" do
      it "returns a single line" do
        result = parse_diff(<<-DIFF)
          diff --git a/path/to/binary b/path/to/binary
          new file mode 100644
          index 0000000..fc03bbf
          Binary files /dev/null and b/path/to/binary differ
        DIFF

        expect(result).to eq(
          "path/to/binary" => [" # Binary file changed"]
        )
      end
    end

    context 'with an unknown line' do
      it 'raises a parse error' do
        expect { parse_diff('oops') }
          .to raise_error(Git::DiffParser::ParseError)
      end
    end

    context 'with bad line order' do
      it 'raises a parse error' do
        diff = <<-DIFF
          +++ b/path/to/changed.txt
          @@ -1,5 +1,6 @@
           Line one
        DIFF
        expect { parse_diff(diff) }.to raise_error(Git::DiffParser::ParseError)
      end
    end

    def parse_diff(diff)
      parser = build_parser(diff.strip_heredoc)
      parser.parse.inject({}) do |result, file|
        result.merge file.name => file.each_line.map(&:to_s)
      end
    end

    def build_parser(diff)
      factory = double('factory')
      allow(factory).to receive(:new) do
        Git::DiffFile.new(Git::DiffLine, 100)
      end

      Git::DiffParser.new(diff, factory)
    end
  end
end
