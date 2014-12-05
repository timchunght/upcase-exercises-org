require 'spec_helper'

describe Admin::ExercisesController do
  it { should be_a(Admin::BaseController) }

  describe "#create" do
    it "redirects to the created exercise" do
      sign_in_as build_stubbed(:admin)
      attributes = attributes_for(:exercise).stringify_keys
      exercise = build_stubbed(:exercise)
      allow(exercise).to receive(:save).and_return(true)
      exercises = stub_service(:exercises)
      allow(exercises).to receive(:new).with(attributes).and_return(exercise)

      post :create, exercise: attributes

      expect(controller).to redirect_to(edit_admin_exercise_url(exercise))
    end
  end
end
