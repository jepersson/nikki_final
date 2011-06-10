class UsersController < ApplicationController
  def index
    if params[:search]
      @users = User.name_like(params[:search]).
        paginate(:page => params[:page], :per_page => 9)
    elsif params[:view] == "stalkers"
      @users = current_user.followers.paginate(:page => params[:page], :per_page => 9)
    elsif params[:view] == "stalking"
      @users = current_user.following.paginate(:page => params[:page], :per_page => 9)
    else
      @users = User.paginate(:page => params[:page], :per_page => 9)
    end

    if @users.empty?
      @message = t :no_users
    end

    respond_to do |format|
      format.html
      format.js {
        render :update do |page|
          # 'page.replace' will replace full "results" block...works for this example
          # 'page.replace_html' will replace "results" inner html...useful elsewhere
          page.replace_html 'results', :partial => 'user_content'
        end
      }
    end
  end

  def new
    @title = t(:registration)
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = t :user_created
      redirect_to posts_path
    else
      @title = t(:registration)
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      if params[:crop]
        render 'crop', :remote => true
      else
        if params[:user][:photo]
          render 'crop', :remote => true
        else
          if params[:user][:crop].blank?
            flash[:notice] = t :updated_user
            redirect_to user_path(:view => "user_posts")
          else
            render 'crop', :remote => true
          end
        end
      end
    else
      render 'edit'
    end
  end

  def show
    @user = User.find(params[:id])
    if params[:view] == "user_stalkers"
      @users = @user.followers.paginate(:page => params[:page], :per_page => 6)
      if @users.empty?
        @message = t :no_users
      end
    elsif params[:view] == "user_stalking"
      @users = @user.following.paginate(:page => params[:page], :per_page => 6)
      if @users.empty?
        @message = t :no_users
      end
    elsif params[:view] == "user_posts"
      @posts = @user.posts.paginate(:page => params[:page], :per_page => 6)
      if @posts.empty?
        @message = t :no_posts
      end
    end

    if @user.position
      res = Geokit::Geocoders::GoogleGeocoder.geocode(@user.position)
      @map = GMap.new("post-location-" + @user.id.to_s)
      @map.center_zoom_init([res.lat,res.lng],6)
      @map.icon_global_init( GIcon.new(:image => @user.photo.url(:mini),
                                       :shadow => "../images/icons/gmap-icon-shadow.png",
                                       :icon_size => GSize.new(40,40),
                                       :shadow_size => GSize.new(64,51),
                                       :icon_anchor => GPoint.new(18,55)),
                             "icon_source")
      icon_source = Variable.new('icon_source')
      source = GMarker.new([res.lat,res.lng], :icon => icon_source)
      @map.overlay_init(source)
    end

    if params[:view] == "user_stalking" or params[:view] == "user_posts" or params[:view] == "user_stalkers"
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            # 'page.replace' will replace full "results" block...works for this example
            # 'page.replace_html' will replace "results" inner html...useful elsewhere
            page.replace_html 'results', :partial => 'show_content'
          end
        }
      end
    end
  end

end
