class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create, :create_with_fb_auth]
  before_filter :require_user, :only => :destroy

  def new
    @title = t(:login)
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = t :login_success
      redirect_to posts_path
    else
      render 'new'
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = t :logout_success
    redirect_to root_path
  end

  def create_with_auth
    auth = request.env["omniauth.auth"]
    user = User.find_by_fbid(auth["uid"]) || User.create_with_auth(auth)
    @user_session = UserSession.new({ :email => user.email, :password => auth["uid"] })
    if @user_session.save
      redirect_to users_path, :notice => "Signed in!"
    else
      redirect_to 'new'
    end
  end

end
