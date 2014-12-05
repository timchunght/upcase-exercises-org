class ObservingFeedback < SimpleDelegator
  def initialize(feedback, observer)
    super(feedback)
    @feedback = feedback
    @observer = observer
  end

  def create_comment(params)
    @feedback.create_comment(params).tap do |comment|
      @observer.comment_created(comment)
    end
  end
end
