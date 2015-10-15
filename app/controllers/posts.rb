require 'sinatra/flash'
get '/users/:u_id/posts/new' do
  @user = User.find(params[:u_id])
  @tiers = @user.tiers.order(number: :asc)
  erb :'/users/create'
end

get '/users/:u_id/posts/:p_id' do
  @user = User.find(params[:u_id])
  @post = Post.find(params[:p_id])
  erb :'/users/post'
end

post '/users/:u_id/posts' do
  @user = User.find(params[:u_id])
  @post = @user.posts.create(params[:post])
  redirect "/users/#{@user.id}/posts/#{@post.id}"
end
