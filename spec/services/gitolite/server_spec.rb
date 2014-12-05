require 'spec_helper'

describe Gitolite::Server do
  describe "#create_clone" do
    it "creates a Gitolite fork and notifies the observer" do
      exercise = double("exercise", slug: "exercise")
      user = double("user", username: "username")
      source = double("source")
      allow(source).to receive(:create_fork)
      clone = double("clone", path: "username/exercise")
      allow(clone).to receive(:head).and_return("sha123")
      repository_finder = double("repository_finder")
      allow(repository_finder).
        to receive(:find_source).
        with(exercise).
        and_return(source)
      allow(repository_finder).
        to receive(:find_clone).
        with(exercise, user).
        and_return(clone)
      observer = double("observer")
      allow(observer).to receive(:clone_created)
      server = build(
        :git_server,
        observer: observer,
        repository_finder: repository_finder,
      )

      server.create_clone(exercise, user)

      expect(source).to have_received(:create_fork).with("username/exercise")
      expect(observer).to have_received(:clone_created).
        with(exercise, user, "sha123")
    end
  end

  describe '#find_clone' do
    it 'delegates to its repository finder' do
      user = double('user')
      exercise = double('exercise')
      repository = double('repository')
      repository_finder = double('repository_finder')
      allow(repository_finder).
        to receive(:find_clone).
        with(exercise, user).
        and_return(repository)
      server = build(:git_server, repository_finder: repository_finder)

      clone = server.find_clone(exercise, user)

      expect(clone).to eq(repository)
    end
  end

  describe "#find_source" do
    it "delegates to its repository finder" do
      exercise = double("exercise")
      repository = double("repository")
      repository_finder = double("repository_finder")
      allow(repository_finder).
        to receive(:find_source).
        with(exercise).
        and_return(repository)
      server = build(:git_server, repository_finder: repository_finder)

      source = server.find_source(exercise)

      expect(source).to eq(repository)
    end
  end

  describe "#fetch_diff" do
    it "updates the solution with a new diff" do
      clone = build_stubbed(:clone, parent_sha: "a_sha")
      diff = "--- +++"
      repository = double("repository")
      allow(repository).to receive(:diff).with("a_sha").and_return(diff)
      repository_finder = double("repository_finder")
      allow(repository_finder).
        to receive(:find_clone).
        with(clone.exercise, clone.user).
        and_return(repository)
      observer = double("observer")
      allow(observer).to receive(:diff_fetched)
      server = build(
        :git_server,
        observer: observer,
        repository_finder: repository_finder,
      )

      server.fetch_diff(clone)

      expect(observer).to have_received(:diff_fetched).with(clone, diff)
    end
  end

  describe '#create_exercise' do
    it 'rewrites the Gitolite config' do
      config_committer = stub_config_committer
      server = build(:git_server, config_committer: config_committer)

      server.create_exercise('new-exercise-name')

      expect(config_committer).to have_received(:write)
        .with('Add exercise: new-exercise-name')
    end
  end

  describe '#add_key' do
    it 'rewrites the Gitolite config' do
      username = 'mrunix'
      config_committer = stub_config_committer
      server = build(:git_server, config_committer: config_committer)

      server.add_key(username)

      expect(config_committer).to have_received(:write)
        .with("Add public key for user: #{username}")
    end
  end

  def stub_config_committer
    double('config_committer').tap do |config_committer|
      allow(config_committer).to receive(:write)
    end
  end
end
