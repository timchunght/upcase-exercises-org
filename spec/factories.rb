FactoryGirl.define do
  sequence :auth_token do |n|
    Digest::MD5.hexdigest("token#{n}")
  end

  sequence :email do |n|
    "user#{n}@example.com"
  end

  sequence :upcase_uid do |n|
    n
  end

  sequence :title do |n|
    "Title #{n} Text"
  end

  sequence :summary do |n|
    "Summary #{n} Text"
  end

  sequence :username do |n|
    sprintf('username%04d', n)
  end

  sequence :public_key_data do |n|
    "ssh-rsa #{n}"
  end

  factory :clone do
    exercise
    user
    parent_sha '1234567890123456789012345678901234567890'
    pending false

    trait :pending do
      parent_sha nil
      pending true
    end
  end

  factory :comment do
    user
    solution
    text 'body'
    location { Comment::TOP_LEVEL }
  end

  factory :exercise do
    title
    summary
    instructions 'Instructions'
    intro 'Introduction'
  end

  factory :git_server, class: 'Gitolite::Server' do
    host 'localhost'
    repository_factory { Git::Repository }
    shell { Gitolite::FakeShell.new }

    initialize_with { new(attributes) }
    to_create {}
  end

  factory :repository, class: 'Git::Repository' do
    host 'example.com'
    path 'repo.git'
    initialize_with { new(attributes) }
    to_create {}
  end

  factory :solution do
    clone

    trait :with_revision do
      revisions { [build(:revision)] }
    end

    trait :with_subscription do
      subscriptions { [build(:subscription, user: user)] }
    end

    after :stub do |solution, attributes|
      extend RSpec::Mocks::ExampleMethods

      allow(solution).
        to receive(:exercise).
        and_return(attributes.clone.exercise)
      allow(solution).
        to receive(:user).
        and_return(attributes.clone.user)
    end
  end

  factory :user do
    auth_token
    avatar_url 'https://gravat.ar/'
    email
    first_name 'Joe'
    last_name 'User'
    upcase_uid
    username
    subscriber true

    factory :admin do
      admin true
    end

    factory :subscriber do
      admin false
    end
  end

  factory :revision do
    solution
    clone { solution.clone }
    diff <<-DIFF.strip_heredoc
      diff --git a/spec/factories.rb b/spec/factories.rb
      index 7794c81..fe91a1b 100644
      --- a/spec/factories.rb
      +++ b/spec/factories.rb
      @@ -84,6 +84,6 @@ FactoryGirl.define do
       end
       factory :revision do
       solution
      -    diff 'diff deploy.rb'
      +    diff another diff
       end
       end
    DIFF
  end

  factory :public_key, class: "Gitolite::PublicKey" do
    ignore do
      user { create(:user) }
    end

    data { generate(:public_key_data) }
    fingerprint "ccab:dd"
    user_id { user.id }
  end

  factory :subscription do
    solution
    user
  end
end
