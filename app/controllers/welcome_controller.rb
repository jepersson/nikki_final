class WelcomeController < ApplicationController  
  
  def index
    @title = "I'm a cat"
    @posts = Post.paginate(:page => params[:page], :per_page => 3)
  end
end