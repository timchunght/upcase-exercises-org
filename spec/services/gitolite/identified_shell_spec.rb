require 'spec_helper'

describe Gitolite::IdentifiedShell do
  describe '#execute' do
    it 'executes the command with an identity file' do
      component = Gitolite::Shell.new
      identity = 'ssh-rsa abcdef'
      shell = Gitolite::IdentifiedShell.new(component, identity)

      result = shell.execute('cat "$IDENTITY_FILE"')

      expect(result.strip).to eq(identity)
    end
  end
end
