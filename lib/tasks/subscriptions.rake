namespace :subscriptions do
  desc "Backfill Subscription to subscribe submitter and commenter to solution"
  task backfill: :environment do
    $stdout.sync = true
    old_subscriptions_count = Subscription.count

    Solution.find_each do |solution|
      Subscription.find_or_create_by!(solution: solution, user: solution.user)
      print "."
    end

    Comment.find_each do |comment|
      Subscription.find_or_create_by!(
        solution: comment.solution,
        user: comment.user
      )
      print "."
    end

    puts
    puts "#{Subscription.count - old_subscriptions_count} subscription(s) added"
  end
end
