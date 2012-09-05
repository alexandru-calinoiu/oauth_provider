require 'oauth/controllers/provider_controller'

class OauthController < ApplicationController
  include OAuth::Controllers::ProviderController

  alias :logged_in? :user_signed_in?
  alias :login_required :authenticate_user!

  def account_info
    oauth_params = OAuth::Helper.parse_header(env["HTTP_AUTHORIZATION"])
    user = OauthToken.find_by_token(oauth_params["oauth_token"]).user

    respond_to do |format|
      format.html { render :text => Decorators::AccountInfo.wrap(user) }
    end
  end

  protected
  # Override this to match your authorization page form
  # It currently expects a checkbox called authorize
  # def user_authorizes_token?
  #   params[:authorize] == '1'
  # end

  # should authenticate and return a user if valid password.
  # This example should work with most Authlogic or Devise. Uncomment it
  # def authenticate_user(username,password)
  #   user = User.find_by_email params[:username]
  #   if user && user.valid_password?(params[:password])
  #     user
  #   else
  #     nil
  #   end
  # end

end
