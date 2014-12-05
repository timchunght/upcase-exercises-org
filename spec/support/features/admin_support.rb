module Features
  def sign_in_as_admin
    user = create(:admin)
    visit admin_root_path(as: user)
  end
end
