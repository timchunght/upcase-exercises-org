require 'spec_helper'

describe 'application/_segment_io.html.erb' do
  context 'when analytics are active' do
    it 'loads the analytics' do
      with_analytics_enabled('fake-key') do
        render 'segment_io', user: nil
      end

      expect(rendered).to include('fake-key')
    end

    context 'when a user is signed in' do
      it 'identifies the signed-in user' do
        user = build_stubbed(:user, upcase_uid: 12345)

        with_analytics_enabled do
          render 'segment_io', user: user
        end

        expect(rendered).to include(user.upcase_uid.to_s)
        expect(rendered).to include(user.email)
        expect(rendered).to include(user.first_name)
        expect(rendered).to include(user.username)
      end

      it 'sends a user_hash to enable secure mode in Intercom' do
        user = build_stubbed(:user, upcase_uid: 12345)
        precalculated_hexdigest =
          '20b24359daf614c0c238dcbccbb0ed9e4f679cbe9868ddbc57d32c603cb8cf70'

        with_analytics_enabled do
          ClimateControl.modify(INTERCOM_APP_SECRET: 'abc123') do
            render 'segment_io', user: user
          end
        end

        expect(rendered).to include('user_hash')
        expect(rendered).to include(precalculated_hexdigest)
      end
    end
  end

  context 'when analytics are not enabled' do
    it 'does not load analytics' do
      render 'segment_io'

      expect(rendered).to be_blank
    end
  end

  def with_analytics_enabled(segment_io_key = 'fake-key', &block)
    options = {
      SEGMENT_IO_KEY: segment_io_key,
      INTERCOM_APP_SECRET: 'fake-intercom-key',
    }
    ClimateControl.modify(options, &block)
  end
end
