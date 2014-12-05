require 'spec_helper'

describe User do
  it { should have_many(:clones).dependent(:destroy) }
  it { should have_many(:public_keys).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it { should allow_value(nil).for(:username) }
  it { should_not allow_value('').for(:username) }
  it { should allow_value('word').for(:username) }
  it { should allow_value('123').for(:username) }
  it { should allow_value('word123').for(:username) }
  it { should allow_value('one-two').for(:username) }
  it { should allow_value('one_two').for(:username) }
  it { should_not allow_value("one\ntwo").for(:username) }
  it { should_not allow_value('one$two').for(:username) }

  it 'validates uniqueness of usernames' do
    create(:user, username: 'existing')
    expect(User.new).to validate_uniqueness_of(:username)
  end

  describe '.admin_usernames' do
    it 'returns usernames for admins alphabetically' do
      create :admin, username: 'def'
      create :admin, username: 'abc'
      create :admin, username: 'ghi'
      create :user, admin: false, username: 'unexpected'

      result = User.admin_usernames

      expect(result).to eq(%w(abc def ghi))
    end
  end

  describe '.by_username' do
    it 'orders users by username' do
      create :user, username: 'def'
      create :user, username: 'abc'
      create :user, username: 'ghi'

      result = User.by_username.pluck(:username)

      expect(result).to eq(%w(abc def ghi))
    end
  end

  describe '#valid?' do
    it { should_not validate_presence_of(:password) }
  end

  describe '#to_param' do
    it 'uses its username' do
      user = build_stubbed(:user, username: 'mrunix')

      expect(user.to_param).to eq(user.username)
    end

    it 'returns a findable value' do
      user = create(:user)

      expect(User.find(user.to_param)).to eq(user)
    end
  end
end
