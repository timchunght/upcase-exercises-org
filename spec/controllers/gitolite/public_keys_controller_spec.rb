require 'spec_helper'

describe Gitolite::PublicKeysController do
  describe '#create' do
    context 'with valid parameters' do
      it 'creates the key and updates Gitolite' do
        git_server = stub_service(:git_server)
        allow(git_server).to receive(:add_key)
        user = build_stubbed(:user)
        public_key = double('public_key', save: true)
        public_keys = stub_service(:current_public_keys)
        allow(public_keys).to receive(:new).and_return(public_key)
        return_to = '/some/path'

        sign_in_as user
        post(
          :create,
          gitolite_public_key: { data: 'ssh-rsa 123' },
          return_to: return_to
        )

        expect(public_keys).to have_received(:new).with(data: 'ssh-rsa 123')
        expect(git_server).to have_received(:add_key).with(user.username)
        expect(controller).to redirect_to(return_to)
      end
    end

    context 'with invalid parameters' do
      it 're-renders the form' do
        user = build_stubbed(:user)
        public_key = double('public_key', save: false)
        public_keys = stub_service(:current_public_keys)
        allow(public_keys).to receive(:new).and_return(public_key)

        sign_in_as user
        post :create, gitolite_public_key: { data: '' }

        expect(controller).to render_template(:new)
      end
    end
  end
end
