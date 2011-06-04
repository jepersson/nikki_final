class UsersController < ApplicationController
  def index
    @title = "All users"
    @users = User.all
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
    @posts = @user.posts.all
    @map = GMap.new("user-location-" + @user.id.to_s)
    @map.control_init(:large_map => true,:map_type => true)
    @map.center_zoom_init([@user.latitude,@user.longitude],6)
    @map.overlay_init(GMarker.new([@user.latitude,@user.longitude],:title => @user.name, :info_window => @user.name))
  end
  
end
