class PostsController < ApplicationController
  def new
  end
  
  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.all
  end
  
  def create
    
  end
end

