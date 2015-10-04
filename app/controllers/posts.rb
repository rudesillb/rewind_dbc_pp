get '/users/:u_id/posts/new' do
  @user = User.find(params[:u_id])
  @tiers = Tier.where(:user_id => :u_id)
  p @user.tiers
  erb :'/users/create'
end

get '/users/:u_id/posts/:p_id' do
  @user = User.find(params[:u_id])
  @post = Post.find(id: params[:p_id])
  erb :'/users/post'
end

post '/users/:u_id/posts' do
  @user = User.find(params[:u_id])
  @post = Post.create(user_id: @user.id, content: params[:post], tier_id: 0)
  redirect "/users/#{@user.id}/posts/#{@post.id}"
end
