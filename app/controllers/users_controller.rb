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
      redirect_to signup_path
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
    elsif params[:view] == "stalking"
      @users = @user.following.paginate(:page => params[:page], :per_page => 6)
    else
      @posts = @user.posts.paginate(:page => params[:page], :per_page => 6)
    end
    
    if @user.position != nil
      res = Geokit::Geocoders::GoogleGeocoder.geocode(@user.position)
      @map = GMap.new("user-location-" + @user.id.to_s)
      @map.control_init(:large_map => true,
                        :map_type => true)
      @map.center_zoom_init([res.lat,res.lng],6)
      @map.overlay_init(GMarker.new([res.lat,res.lng],:title => @user.name, 
                                                      :info_window => @user.name))
    end
  end
  
end
