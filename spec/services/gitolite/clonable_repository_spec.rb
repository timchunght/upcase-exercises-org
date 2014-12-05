require 'spec_helper'

describe Gitolite::ClonableRepository do
  it_behaves_like :repository_decorator do
    def decorate(repository)
      Gitolite::ClonableRepository.new(repository, double('shell'))
    end
  end

  describe '#clone' do
    it 'creates temporarily cloned repository' do
      shell = Gitolite::FakeShell.new
      repository = double('repository', url: 'git@something:example.git')
      result = "Block wasn't called"
      stub_clone('local') do
        Gitolite::ClonableRepository.new(repository, shell).in_local_clone do
          result = Dir.glob('*')
        end
      end

      expect(result).to eq(%w(local))
    end
  end

  def stub_clone(filename)
    Gitolite::FakeShell.with_stubs do |stubs|
      stubs.add(%r{git clone [^ ]+ \.}) do |target|
        FileUtils.touch(filename)
      end
      yield
    end
  end
end
