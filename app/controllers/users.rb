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
    Tier.create(user_id: @user.id, number: 0, title: "Personal")
    Tier.create(user_id: @user.id, number: 10, title: "Public")
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
    redirect "/users/#{user.id}"
  else
    erb :'/users/login'
  end
end

get '/users/:u_id' do
  @user = User.find(params[:u_id])
  @post = Post.find_by(user_id: @user.id)
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

get '/users/:u_id/friends/new' do
  @user = User.find(params[:u_id])
  erb :'/users/addfriend'
end

post '/users/:u_id/friends' do
  user = User.find(params[:u_id])
  friend = Friend.create(friend_id: params[:u_id], user_id: session[:user_id], tier: params[:tier], seen: nil)
  redirect "/users/#{session[:user_id]}/friends"
end

get '/users/:u_id/friends' do
  @user = User.find(params[:u_id])
  if @user.id != session[:user_id]
    redirect 'users/#{:u_id}'
  end
  erb :'/users/friends'
end

get '/users/:u_id/tiers/new' do
  @user = User.find(params[:u_id])
  erb :'/users/addtier'
end

post '/users/:u_id/tiers' do
  user = User.find(params[:u_id])
  tier = Tier.create(title: params[:title], number: params[:number], user_id: session[:user_id])
  redirect "/users/#{session[:user_id]}/tiers"
end

get '/users/:u_id/tiers' do
  @user = User.find(params[:u_id])
  erb :'/users/tiers'
end

get '/users/:u_id/tier/:t_id' do
  @tier = Tier.find_by(number: params[:t_id])
  @user = User.find(params[:u_id])
  @friends = Friend.where(friend_id: params[:u_id])
  if @user.id != session[:user_id]
    redirect 'users/#{:u_id}'
  end
  erb :'/users/tier'
end
