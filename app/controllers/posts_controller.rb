class PostsController < ApplicationController
  
  def index
    @posts = Post.all
  end

  def show
    @comment = Comment.new
    @post = Post.find(params[:id])
    @map = GMap.new("post-location-" + @post.id.to_s)
    @map.control_init(:large_map => true,:map_type => true)
    @map.center_zoom_init([@post.latitude,@post.longitude],6)
    @map.overlay_init(GMarker.new([@post.latitude,@post.longitude],:title => @post.title, :info_window => @post.user.name))
  end
  
  def new
    @post = Post.new
  end

  def create
    @post = Post.new(params[:post])
    @post.user = current_user
    if @post.save
      redirect_to posts_path
    else
      redirect_to new_post_path
    end
  end
  
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to root_path
  end
  
end

