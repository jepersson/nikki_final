class WelcomeController < ApplicationController  
  
  def index
    @title = t(:welcome)
    @posts = Post.paginate(:page => params[:page], :per_page => 3)
    @user_session = UserSession.new
     
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
