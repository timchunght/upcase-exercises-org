require 'spec_helper'

describe Git::LoggingObserver do
  describe '#clone_created' do
    it 'logs the exercise, user, and sha' do
      logger = double('logger')
      allow(logger).to receive(:info)
      exercise = double('exercise', title: 'exercise')
      user = double('user', username: 'user')
      sha = 'sha123'
      observer = Git::LoggingObserver.new(logger)

      observer.clone_created(exercise, user, sha)

      expect(logger).to have_received(:info).
        with('Cloned exercise for user at sha123')
    end
  end

  describe '#diff_fetched' do
    it 'logs clone and diff size' do
      logger = double('logger')
      allow(logger).to receive(:info)
      clone = double('clone', title: 'exercise', username: 'user')
      diff = '123456789'
      observer = Git::LoggingObserver.new(logger)

      observer.diff_fetched(clone, diff)

      expect(logger).to have_received(:info).
        with('Fetched diff for user/exercise (9 bytes)')
    end
  end
end
