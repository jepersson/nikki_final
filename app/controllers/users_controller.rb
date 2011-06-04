class UsersController < ApplicationController
  def index
   if params[:search]
      @users = User.name_like(params[:search]).
                    paginate(:page => params[:page], :per_page => 9)

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
  end
  
end
