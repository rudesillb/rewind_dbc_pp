require 'sinatra/flash'
get '/users/login' do

  erb :'/users/login'
end

get '/users/register' do
  erb :'/users/register'
end

post '/users/register' do
  if (params[:user][:password].length) < 6
    flash[:error] = "Passwords must be six characters or longer"
    redirect '/users/register'
  elsif params[:user][:first_name] == ""
    flash[:error] = "You must enter a first name"
    redirect '/users/register'
  elsif params[:user][:last_name] == ""
    flash[:error] = "You must enter a last name"
    redirect '/users/register'
  elsif not /@{1}/ =~ params[:user][:email]
    flash[:error] = "That doesn't look like a valid email"
    redirect '/users/register'
  end
  user = params[:user]
  user[:first_name] = user[:first_name].downcase.capitalize!
  user[:last_name] = user[:last_name].downcase.capitalize!
  user[:email] = user[:email].downcase!
  @user = User.new(user)
  if @user.save
    auth_login(@user)

    @user.tiers.create(number: 0, title: "Personal")
    @user.tiers.create( number: 10, title: "Public")

    redirect "/users/#{@user.id}"
  else
    flash[:error] = "That user already exists"
    redirect '/users/register'
  end
  @user = nil
end

post '/users/login' do
  param = params
  param[:email] = param[:email].downcase!
  user = User.find_by(email: param[:email])
  if (user && user.password_hash = params[:password])
    auth_login(user)
    redirect "/users/#{user.id}"
  else
    flash[:error] = "Incorrect email or password"
    redirect '/users/login'
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
  if params[:tier] == nil
    flash[:error] = "You must enter a tier"
    redirect '/users/:u_id/friends'
  end
  user.friends.create(friend_id: params[:u_id], tier: params[:tier], seen: nil)
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
  if params[:u_id] != session[:user_id]
    redirect "/users/#{session[:user_id]}/tiers/new"
  end
  tiers_left = (1..9).to_a
  tier_names = []
  user = User.find(params[:u_id])
  user.tiers.each do |tier|
    tier_names << tier.title
    tiers_left.delete(tier.number)
  end
  if params[:number] == ""
    flash[:error] = "You must enter a tier number"
    redirect "/users/#{session[:user_id]}/tiers/new"
  elsif (params[:number].to_i > 9) || (params[:number].to_i < 1)
    flash[:error] = "Tier numbers must be between 0 and 10"
    redirect "/users/#{session[:user_id]}/tiers/new"
  elsif params[:title] == ""
    flash[:error] = "You must enter a tier title"
    redirect "/users/#{session[:user_id]}/tiers/new"
  elsif not tiers_left.include?(params[:number].to_i)
    flash[:error] = "That tier number already exists"
    redirect "/users/#{session[:user_id]}/tiers/new"
  elsif not tier_names.include?(params[:title])
    flash[:error] = "That tier number already exists"
    redirect "/users/#{session[:user_id]}/tiers/new"
  end
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
  @query = params[:search]
  param = params
  param[:search] = param[:search].downcase.capitalize!
  @users = User.where("first_name LIKE ? OR last_name LIKE ?", param[:search], param[:search])

  erb :'/search/results'
end
