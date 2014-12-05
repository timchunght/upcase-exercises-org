require 'spec_helper.rb'

describe Gitolite::Shell do
  describe '#execute' do
    it 'runs commands and captures output' do
      shell = Gitolite::Shell.new

      result = shell.execute('echo hello')

      expect(result.strip).to eq('hello')
    end

    it 'captures STDERR on failure' do
      shell = Gitolite::Shell.new

      expect { shell.execute('echo expected_message >&2 && exit 1') }.
        to raise_error(/expected_message/)
    end
  end
end
