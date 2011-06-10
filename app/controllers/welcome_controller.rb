class WelcomeController < ApplicationController  
  
  def index
    @title = t(:welcome)
    @posts = Post.paginate(:page => params[:page], :per_page => 3)
  end
end
