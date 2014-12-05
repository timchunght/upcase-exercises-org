class CommentLocator
  LINE_NUMBER_PLACEHOLDER = "?"

  pattr_initialize [:comments, :revision]

  def inline_comments_for(file_name, line_number)
    comments_for(location_for(file_name, line_number))
  end

  def top_level_comments
    comments_for(Comment::TOP_LEVEL)
  end

  def location_for(file_name, line_number)
    "#{revision.id}:#{file_name}:#{line_number}"
  end

  def location_template_for(file_name)
    location_for(file_name, LINE_NUMBER_PLACEHOLDER)
  end

  def create_comment(params)
    comments.create(params)
  end

  private

  def comments_for(location)
    comments_by_location[location] || []
  end

  def comments_by_location
    @comments_by_location ||= group_comments_by_location
  end

  def group_comments_by_location
    comments.group_by(&:location)
  end
end
