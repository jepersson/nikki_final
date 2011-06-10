class WelcomeController < ApplicationController  
  
  def index
    @title = "I'm a cat"
    @posts = Post.paginate(:page => params[:page], :per_page => 3)
    
    respond_to do |format|
      format.html
      format.js {
        render :update do |page|
          page.replace_html 'results', :partial => 'welcome_content'
        end
      }
    end
  end
end
