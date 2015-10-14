get '/' do
  @friendpost = {}
  if session[:user_id]
    visited = {}
    user = User.find(session[:user_id])
    user.friends.each do |friend|
      visited[friend.friend_id] = friend.seen
    end
    visited.each do |key,value|
      count = 0
      frnd = User.find(key)
      frnd.posts.each do |post|
        if post.created_at >= value
          count += 1
        end
      end
      if count > 0
        @friendpost[frnd] = count
      end
    end
  end
  erb :index
end


