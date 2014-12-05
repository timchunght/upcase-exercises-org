module Features
  def have_translation(*args)
    have_content I18n.t(*args)
  end
end
