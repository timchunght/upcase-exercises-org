require 'spec_helper'

describe Git::Exercise do
  it 'decorates to its component' do
    exercise = double('exercise', title: 'expected title')
    server = double('server')
    git_exercise = Git::Exercise.new(exercise, server)

    expect(git_exercise).to be_a(SimpleDelegator)
    expect(git_exercise.title).to eq('expected title')
  end

  describe '#source' do
    it 'returns the source Git repository for this exercise' do
      repository = double('repository')
      exercise = double('exercise')
      server = double('server')
      allow(server).
        to receive(:find_source).
        with(exercise).
        and_return(repository)
      git_exercise = Git::Exercise.new(exercise, server)

      expect(git_exercise.source).to eq(repository)
    end
  end
end
