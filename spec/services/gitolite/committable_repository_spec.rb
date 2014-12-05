require 'spec_helper'

describe Gitolite::CommittableRepository do
  it_behaves_like :repository_decorator do
    def decorate(repository)
      Gitolite::CommittableRepository.new(repository, double('shell'))
    end
  end

  describe '#commit' do
    it 'performs a commit in a local checkout' do
      shell = Gitolite::FakeShell.new
      repository = FakeClonableRepository.new

      result = stub_clone do
        committable_repository =
          Gitolite::CommittableRepository.new(repository, shell)
        committable_repository.commit('Message') do
          FileUtils.touch('example.txt')
        end
      end

      expect(result.added).to eq(['example.txt'])
      expect(result.committed).to eq(result.added)
      expect(result.pushed).to eq(result.committed)
      expect(result.message).to eq('Message')
    end
  end

  def stub_clone
    state = CommitState.new

    Gitolite::FakeShell.with_stubs do |stubs|
      stubs.add(%r{git add -A}) do
        state.add
      end

      safe_commit_pattern =
        %r{git diff-index --quiet HEAD \|\| git commit -m "(.*)"}
      stubs.add(safe_commit_pattern) do |message|
        state.commit message
      end

      stubs.add(%r{git push}) do
        state.push
      end

      yield
    end

    state
  end
end
