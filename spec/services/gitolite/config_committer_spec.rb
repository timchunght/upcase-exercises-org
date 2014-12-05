require 'spec_helper'

describe Gitolite::ConfigCommitter do
  describe '#write' do
    it 'clones the config, rewrites it, and pushes it' do
      message = 'Updated config'
      repository_factory = double('factory')
      config_writer = stub_config_writer
      commit_creator = stub_committable_repository(repository_factory)
      gitolite_config_committer = Gitolite::ConfigCommitter.new(
        repository_factory: repository_factory,
        config_writer: config_writer
      )

      gitolite_config_committer.write(message)

      expect(config_writer).to have_received(:write)
      expect(commit_creator).to have_received(:commit).with(message)
    end

    def stub_config_writer
      double('gitolite_config_writer').tap do |config|
        allow(config).to receive(:write)
      end
    end

    def stub_committable_repository(repository_factory)
      double('repository').tap do |repository|
        allow(repository_factory).
          to receive(:new).
          with(path: Gitolite::ConfigCommitter::ADMIN_REPO_NAME).
          and_return(repository)
        allow(repository).to receive(:commit).and_yield
      end
    end
  end
end
