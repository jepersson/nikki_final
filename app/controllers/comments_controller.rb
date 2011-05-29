class CommentsController < ApplicationController
  def new
    @comment = Comment.new
  end
  
  def create
    @comment = current_user.comments.build(params[:comment])
    if @comment.save
      redirect_to posts_index
    else
      render 'root'
    end
  end
end
