helpers do

  def auth_login(user)
    session[:user_id] = user.id
  end

end
