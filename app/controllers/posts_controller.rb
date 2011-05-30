class PostsController < ApplicationController

  def new
  end
  
  def index
    @posts = Post.all
  end

  def show
    @comment = Comment.new
    @post = Post.find(params[:id])
    @comments = @post.comments.all  
    @map = GMap.new("map-" + @post.id.to_s)
    @map.control_init(:large_map => true,:map_type => true)
    @map.center_zoom_init([@post.longitude,@post.latitude],6)
    @map.overlay_init(GMarker.new([@post.longitude,@post.latitude],:title => @post.title, :info_window => @post.user.name))
  end

  def create
    
  end
  
  
end

