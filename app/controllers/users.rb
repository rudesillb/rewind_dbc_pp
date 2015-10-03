get '/users/login' do

  erb :'/users/login'
end

get '/users/register' do
  erb :'/users/register'
end

post '/users/register' do
  @user = User.new(params[:user])
  if @user.save
    auth_login(@user)
    redirect "/users/#{@user.id}"
  else
    erb :'/users/register'
  end

end

post '/users/login' do
  user = User.find_by(email: params[:email])
  p user
  if (user && user.password_hash = params[:password])
    auth_login(user)
    p "&" * 100
    p user
    p "&" * 100
    redirect "/users/#{user.id}"
  else
    erb :'/users/login'
  end
end

get '/users/secretpage' do
  if auth_current_user
    erb :'/users/secretpage'
  else
    redirect "/"
  end
end

get '/users/:id' do
  @user = User.find(params[:id])
  if auth_current_user
    erb :'/users/profile'
  else
    redirect "/"
  end
end

get '/logout' do
  session.destroy
  redirect '/'
end



