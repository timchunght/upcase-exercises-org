class Gitolite::PublicKeysController < ApplicationController
  def create
    @public_key = build_public_key
    if @public_key.save
      add_public_key_to_gitolite
      redirect_to return_to
    else
      render :new
    end
  end

  private

  def build_public_key
    dependencies[:current_public_keys].new(data: public_key_data)
  end

  def add_public_key_to_gitolite
    dependencies[:git_server].add_key(current_user.username)
  end

  def public_key_data
    public_key_attributes[:data]
  end

  def public_key_attributes
    params.require(:gitolite_public_key).permit(:data)
  end

  def return_to
    params[:return_to]
  end
end
