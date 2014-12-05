require 'spec_helper'

describe Gitolite::RepositoryFinder do
  describe '#find_clone' do
    it 'builds a repository based on the exercise slug and username' do
      user = double('user', username: 'username')
      exercise = double('exercise', slug: 'exercise')
      finder = Gitolite::RepositoryFinder.new(Git::Repository)

      result = finder.find_clone(exercise, user)

      expect(result.path).to eq('username/exercise')
    end
  end

  describe '#find_source' do
    it 'returns the source repository for the given exercise' do
      exercise = double('exercise', slug: 'exercise')
      finder = Gitolite::RepositoryFinder.new(Git::Repository)

      result = finder.find_source(exercise)

      expect(result.path).to eq('sources/exercise')
    end
  end
end
