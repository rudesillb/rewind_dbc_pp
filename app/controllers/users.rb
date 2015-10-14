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

    @user.tiers.create(number: 0, title: "Personal")
    @user.tiers.create( number: 10, title: "Public")

    redirect "/users/#{@user.id}"
  else
    erb :'/users/register'
  end
  @user = nil
end

post '/users/login' do
  user = User.find_by(email: params[:email])
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
  @visiter = Friend.where(user_id: session[:user_id], friend_id: @user.id)
  p @visiter
  if @visiter != []
    @visiter.first.seen = Time.now
    @visiter.first.save
  end
  erb :'/users/profile'
end

get '/logout' do
  session.destroy
  redirect '/'
end

get '/users/:u_id/friends/new' do
  @user = User.find(session[:user_id])
  @tiers = @user.tiers.order(number: :asc)
  erb :'/users/addfriend'
end

post '/users/:u_id/friends' do
  user = User.find(session[:user_id])
  user.friends.create(friend_id: params[:u_id], tier: params[:tier], seen: nil)
  p params
  redirect "/users/#{params[:u_id]}"
end

get '/users/:u_id/friends' do
  @user = User.find(params[:u_id])
  if @user.id != session[:user_id]
    redirect "users/#{params[:u_id]}"
  end
  erb :'/users/friends'
end

get '/users/:u_id/tiers/new' do
  @user = User.find(params[:u_id])
  erb :'/users/addtier'
end

post '/users/:u_id/tiers' do
  user = User.find(params[:u_id])
  user.tiers.create(title: params[:title], number: params[:number])
  redirect "/users/#{session[:user_id]}/tiers"
end

get '/users/:u_id/tiers' do
  @user = User.find(params[:u_id])
  @tiers = @user.tiers.order(number: :asc)
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

get '/search/results' do
  @users = User.where("first_name LIKE ? OR last_name LIKE ?", params[:search], params[:search])
  @query = params[:search]

  erb :'/search/results'
end
