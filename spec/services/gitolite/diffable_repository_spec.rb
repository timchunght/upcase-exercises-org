require 'spec_helper'

describe Gitolite::DiffableRepository do
  it_behaves_like :repository_decorator do
    def decorate(repository)
      Gitolite::DiffableRepository.new(repository, double('shell'))
    end
  end

  describe '#diff' do
    it 'performs a diff in the local directory' do
      shell = Gitolite::FakeShell.new
      repository = FakeClonableRepository.new
      diff_creator = Gitolite::DiffableRepository.new(repository, shell)

      stub_diff do
        diff_creator.diff('some_sha')
      end

      expect(shell).to have_executed_command(
        'git diff some_sha --unified=10000'
      )
    end

    def stub_diff
      Gitolite::FakeShell.with_stubs do |stubs|
        ShellStubber.new(stubs).diff('diff deploy.rb')

        yield
      end
    end
  end
end
