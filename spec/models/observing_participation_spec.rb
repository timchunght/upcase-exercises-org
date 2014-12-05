require "spec_helper"

describe ObservingParticipation do
  it "delegates to participation" do
    participation = double("participation", some_method: nil)
    observing_participation = ObservingParticipation.new(participation, double)

    observing_participation.some_method

    expect(participation).to have_received(:some_method)
  end

  describe "#create_clone" do
    it "tracks clone creation when a clone is created" do
      participation = double("participation", create_clone: nil)
      observer = double("observer", clone_created: nil)
      observing_participation =
        ObservingParticipation.new(participation, observer)

      observing_participation.create_clone

      expect(observer).to have_received(:clone_created)
    end
  end

  describe "#create_solution" do
    it "tracks solution submission when a solution is created" do
      solution = double("wrapped solution")
      participation = double("participation", create_solution: solution)
      observer = double("observer", solution_submitted: nil)
      observing_participation =
        ObservingParticipation.new(participation, observer)

      observing_participation.create_solution

      expect(observer).to have_received(:solution_submitted).with(solution)
    end
  end

  describe "#push_to_clone" do
    it "tracks revision submission when a revision is created" do
      participation = double("participation", push_to_clone: nil)
      observer = double("observer", revision_submitted: nil)
      observing_participation =
        ObservingParticipation.new(participation, observer)

      observing_participation.push_to_clone

      expect(observer).to have_received(:revision_submitted)
    end
  end
end
