class PostsController < ApplicationController
  
  def index
    if params[:search]
      @posts = Post.title_like(params[:search]).
                    paginate(:page => params[:page], :per_page => 9)
    else
      @posts = Post.paginate(:page => params[:page], :per_page => 9)
    end
  end

  def show
    @comment = Comment.new
    @post = Post.find(params[:id])
    @map = GMap.new("post-location-" + @post.id.to_s)
    @map.control_init(:large_map => true,:map_type => true)
    @map.center_zoom_init([@post.longitude,@post.latitude],6)
    @map.overlay_init(GMarker.new([@post.longitude,@post.latitude],:title => @post.title, 
                                                                   :info_window => @post.user.name))
  end
  
  def new
    @title = "Create Post"
    @post = Post.new
  end

  def create
    @post = Post.new(params[:post])
    @post.user = current_user
    if @post.save
      if params[:user]
        redirect_to posts_path
      else
        render 'crop'
      end
    else
      render 'new'
    end
  end
  
  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
      if params[:post][:crop].blank?
        redirect_to posts_path
      else
        render 'crop', :remote => true
      end
    else
      render 'edit'
    end
  end
  
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to root_path
  end
  
end

