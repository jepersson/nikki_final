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

  def quickview
    @post = Post.find(params[:id])
    @view = params[:view]
  end
  
end

