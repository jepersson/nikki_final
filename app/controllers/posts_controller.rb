class PostsController < ApplicationController

  def index
    if params[:search]
      @posts = Post.title_like(params[:search]).
        paginate(:page => params[:page], :per_page => 9)
    elsif params[:view] == "my"
      @posts = current_user.posts.paginate(:page => params[:page], :per_page => 9)
    elsif params[:view] == "stalking" or current_user != nil
      @posts = current_user.following.collect{ |p| p.posts }.flatten.sort_by { |p| p.created_at }.reverse.paginate(:page => params[:page], :per_page => 9, :order => 'created_at DESC')
    else
      @posts = Post.paginate(:page => params[:page], :per_page => 9)
    end
  end

  def show
    @comment = Comment.new
    @post = Post.find(params[:id])

    if @post.position != nil
      res = Geokit::Geocoders::GoogleGeocoder.geocode(@post.position)

      @map = GMap.new("post-location-" + @post.id.to_s)
      @map.control_init(:large_map => true,
                        :map_type => true)
      @map.center_zoom_init([res.lat,res.lng],8)
      @map.overlay_init(GMarker.new([res.lat,res.lng],:title => @post.title,
                                    :info_window => @post.user.name))
    end
  end

  def new
    @title = "Create Post"
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(params[:post])
   # @post.user = current_user
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
