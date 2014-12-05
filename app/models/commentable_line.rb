class CommentableLine < SimpleDelegator
  def initialize(diff_line, comment_locator)
    super(diff_line)
    @diff_line = diff_line
    @comment_locator = comment_locator
  end

  def comments
    comment_locator.inline_comments_for(file_name, number)
  end

  def location
    comment_locator.location_for(diff_line.file_name, diff_line.number)
  end

  private

  attr_reader :comment_locator, :diff_line
end
