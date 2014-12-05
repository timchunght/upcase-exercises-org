class ClonesController < ApplicationController
  layout false
  before_filter :require_xhr

  def create
    if current_user.username?
      dependencies[:current_participation].create_clone
    else
      render partial: 'usernames/edit', locals: { user: current_user }
    end
  end

  def show
    @overview = dependencies[:current_overview]
  end

  private

  def require_xhr
    unless request.xhr?
      head :bad_request
    end
  end
end
