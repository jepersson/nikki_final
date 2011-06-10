class AuthenticationsController < ApplicationController
  def create
    omniauth = request.env['omniauth.auth']
    authentication = Authentication.
      find_by_provider_and_uid(omniauth['provider'],
                               omniauth['uid'])

    if authentication
      # Already registered user
      flash[:notice] = t :login_success
      sign_in_and_redirect(authentication.user)
    else
      # New user
      user = User.new
      user.save(:validate => false)
      user.authentications.build(:provider  => omniauth['provider'],
                                 :uid => omniauth['uid'])
      user.apply_omniauth(omniauth)
      if user.save
        flash[:info] = t :user_created
        sign_in_and_redirect(user)
      else
        session[:omniauth] = omniauth.except('extra')
        redirect_to signup_path
      end
    end
  end

  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    redirect_to authentications_url
  end

  private

    def sign_in_and_redirect(user)
      unless current_user
        user_session =
          UserSession.new(User.find_by_single_access_token(user.single_access_token))
        user_session.save
      end
      redirect_to posts_path
    end
end
