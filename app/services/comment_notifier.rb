class CommentNotifier
  pattr_initialize :notification_factory

  def comment_created(comment)
    comment.subscribers.each do |subscriber|
      notification_factory.new(comment: comment, recipient: subscriber).deliver
    end
  end
end
