require 'spec_helper'

describe UsernamesController do
  describe '#update' do
    context 'with valid parameters' do
      it 'redirects back' do
        user_params = { 'username' => 'username' }
        user = build_stubbed(:user)
        exercise = build_stubbed(:exercise)
        allow(user).
          to receive(:update_attributes).
          with(user_params).
          and_return(true)

        sign_in_as user
        put :update, user: user_params, exercise_id: exercise.to_param

        expect(controller).to redirect_to(exercise_path(exercise))
      end
    end

    context 'with invalid parameters' do
      it 're-renders the form' do
        user = build_stubbed(:user)
        exercise = build_stubbed(:exercise)
        allow(user).to receive(:update_attributes).and_return(false)

        sign_in_as user
        put :update, user: { username: '' }, exercise_id: exercise.to_param

        expect(controller).to render_template(:edit)
      end
    end
  end
end
