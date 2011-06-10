class PostsController < ApplicationController
  
  def index
    if params[:search]
      @posts = Post.title_like(params[:search]).
                    paginate(:page => params[:page], :per_page => 9)
      if @posts.empty?
        @posts = Post.content_like(params[:search]).
                      paginate(:page => params[:page], :per_page => 9)
        if @posts.empty?
          @message = t :no_posts_search
        end
      end
    elsif params[:view] == "my"
      @posts = current_user.posts.paginate(:page => params[:page], :per_page => 9)
      if @posts.empty?
        @message = t :no_posts_posted
      end
    elsif params[:view] == "stalking" or current_user != nil
      @posts = current_user.following.collect{ |p| p.posts }.flatten.sort_by { |p| p.created_at }.reverse.paginate(:page => params[:page], :per_page => 9, :order => 'created_at DESC')
      if @posts.empty?
        @message = t :no_posts_stalking
      end
    else
      @posts = Post.paginate(:page => params[:page], :per_page => 9)
      if @posts.empty?
        @message = t :no_posts
      end
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
      @map.icon_global_init( GIcon.new(:image => "../images/user/seba-small.png",
                                       :shadow => "../images/icons/gmap-icon-shadow.png",
                                       :icon_size => GSize.new(40,40),
                                       :shadow_size => GSize.new(64,51),
                                       :icon_anchor => GPoint.new(18,55)), 
                                       "icon_source")
      icon_source = Variable.new('icon_source') 
      source = GMarker.new([res.lat,res.lng], :icon => icon_source)
      @map.overlay_init(source)
    end
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
        redirect_to posts_path(:view => "my")
      else
        render 'crop'
      end
    else
      render 'new'
    end
  end

  def edit
    @post = Post.find(params[:id])
  end
  
  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
      if params[:crop]
        render 'crop', :remote => true
      else
        if params[:post][:photo]
          render 'crop', :remote => true
        else
          if params[:post][:crop].blank?
            redirect_to posts_path(:view => "my")
          else
            render 'crop', :remote => true
          end
        end
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

