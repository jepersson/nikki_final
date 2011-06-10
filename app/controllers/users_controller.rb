class UsersController < ApplicationController
  def index
   if params[:search]
      @users = User.name_like(params[:search]).
                    paginate(:page => params[:page], :per_page => 9)
      if @users.empty?
        redirect_to posts_path(:search => params[:search])
      end
    elsif params[:view] == "stalkers"
      @users = current_user.followers.paginate(:page => params[:page], :per_page => 9)
    elsif params[:view] == "stalking"
      @users = current_user.following.paginate(:page => params[:page], :per_page => 9)
    else
      @users = User.paginate(:page => params[:page], :per_page => 9)
    end
    
    if @users.empty?
      @message = t :no_users
    end
  end
  
  def new
    @title = "Sign up!"
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to users_path
    else
      @title = "Sign up!"
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def show
    @user = User.find(params[:id])
    if params[:view] == "stalkers"
      @users = @user.followers.paginate(:page => params[:page], :per_page => 6)
      if @users.empty? or @posts.empty?
        @message = t :no_users
      end
    elsif params[:view] == "stalking"
      @users = @user.following.paginate(:page => params[:page], :per_page => 6)
      if @users.empty? or @posts.empty?
        @message = t :no_users
      end
    else
      @posts = @user.posts.paginate(:page => params[:page], :per_page => 6)
      if @posts.empty? or @posts.empty?
        @message = t :no_posts
      end
    end
    
    
    
    if @user.position != nil
      res = Geokit::Geocoders::GoogleGeocoder.geocode(@user.position)
      @map = GMap.new("post-location-" + @user.id.to_s)
      @map.control_init(:large_map => true,
                        :map_type => true)
      @map.center_zoom_init([res.lat,res.lng],6)
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
  
  
end
