require 'spec_helper'

describe ClonesController do
  describe '#create' do
    context 'for a user with a username' do
      it 'creates a new clone for the user' do
        exercise = build_stubbed(:exercise)
        participation = stub_service(:current_participation)
        allow(participation).to receive(:create_clone)
        user = build_stubbed(:user, username: 'hello')

        sign_in_as user
        xhr :post, :create, exercise_id: exercise.to_param

        expect(controller).not_to render_with_layout
        expect(participation).to have_received(:create_clone)
      end
    end

    context 'for a user without a username' do
      it 'prompts for a username' do
        exercise = build_stubbed(:exercise)
        participation = stub_service(:current_participation)
        allow(participation).to receive(:create_clone)
        user = build_stubbed(:user, username: '')

        sign_in_as user
        xhr :post, :create, exercise_id: exercise.to_param

        expect(controller).to render_template(partial: 'usernames/_edit')
        expect(participation).not_to have_received(:create_clone)
      end
    end
  end

  describe '#show' do
    context 'with an existing clone' do
      it 'renders success' do
        show_overview clone: double("clone").wrapped

        expect(controller).to respond_with(:success)
      end
    end

    context "as a non-XHR request" do
      it "raises an invalid request error" do
        sign_in
        get :show, exercise_id: "1"

        expect(controller).to respond_with(:bad_request)
      end
    end

    def show_overview(stubs)
      exercise = build_stubbed(:exercise)
      overview = stub_service(:current_overview)
      allow(overview).to receive_messages(stubs)

      sign_in
      xhr :get, :show, exercise_id: exercise.to_param
    end
  end
end
