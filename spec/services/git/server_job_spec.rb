require "spec_helper"

describe Git::ServerJob do
  describe "#perform" do
    it "calls the correct method on the Git server" do
      git_server = double("git_server")
      allow(git_server).to receive(:expected_method)
      stub_dependencies immediate_git_server: git_server
      args = %w(one two)
      job = Git::ServerJob.new(method_name: "expected_method", data: args)

      job.perform

      expect(git_server).to have_received(:expected_method).with(*args)
    end
  end

  describe "#error" do
    it "sends notifications" do
      error = StandardError.new("oops")
      error_notifier = double("error_notifier")
      allow(error_notifier).to receive(:notify)
      stub_dependencies error_notifier: error_notifier
      job = Git::ServerJob.new(method_name: "expected_method", data: [])

      job.error(job, error)

      expect(error_notifier).to have_received(:notify).with(error)
    end
  end

  def stub_dependencies(dependencies)
    allow(Payload::RailsLoader).to receive(:load).and_return(dependencies)
  end
end
