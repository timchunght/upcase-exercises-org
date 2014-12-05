class CommentableFile < SimpleDelegator
  def initialize(diff_file, comment_locator)
    super(diff_file)

    @diff_file = diff_file
    @comment_locator = comment_locator
  end

  def location_template
    comment_locator.location_template_for(diff_file.name)
  end

  private

  attr_reader :diff_file, :comment_locator
end
