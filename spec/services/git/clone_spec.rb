require 'spec_helper'

describe Git::Clone do
  it 'decorates to its component' do
    clone = double('clone', title: 'expected title')
    server = double('server')
    git_clone = Git::Clone.new(clone, server)

    expect(git_clone).to be_a(SimpleDelegator)
    expect(git_clone.title).to eq('expected title')
  end

  describe '#repository' do
    it 'returns the repository for itself' do
      user = double('user')
      exercise = double('exercise')
      repository = double('repository')
      server = double('server')
      allow(server).
        to receive(:find_clone).
        with(exercise, user).
        and_return(repository)
      clone = double('clone', user: user, exercise: exercise)
      git_clone = Git::Clone.new(clone, server)

      result = git_clone.repository

      expect(result).to eq(repository)
    end
  end
end
