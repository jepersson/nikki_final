class CommentsController < ApplicationController
  def new
    @comment = Comment.new
  end
  
  def create
    @comment = current_user.comments.build(params[:comment])
    if @comment.save
     redirect_to :back
    else
      redirect_to root_path
    end
  end
end
