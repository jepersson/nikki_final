class PostsController < ApplicationController
  
  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
  end
  
  def new
    @post = Post.new
  end
  
  def create
    @post = Post.new(params[:post])
    @post.user = current_user
    if @post.save
      redirect_to posts_path
    else
      redirect_to new_post_path
    end
  end
  
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to root_path
  end
end

