require 'spec_helper'

describe Gitolite::RepositoryWithHistory do
  it_behaves_like :repository_decorator do
    def decorate(repository)
      Gitolite::RepositoryWithHistory.new(repository, double('shell'))
    end
  end

  describe '#head' do
    it 'grabs the revision using the git server' do
      shell = Gitolite::FakeShell.new
      repository = FakeClonableRepository.new
      result = stub_revision do
        Gitolite::RepositoryWithHistory.new(repository, shell).head
      end

      expect(result).to eq '05aa1bb6146da8d041eb37c4931e'
    end
  end

  def stub_revision
    Gitolite::FakeShell.with_stubs do |stubs|
      ShellStubber.new(stubs).
        head_sha('05aa1bb6146da8d041eb37c4931e')

      yield
    end
  end
end
