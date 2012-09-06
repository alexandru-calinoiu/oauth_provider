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

  def oauth1_authorize
    unless @token
      render :action=>"authorize_failure"
      return
    end

    unless @token.invalidated?
      if user_authorizes_token?
        @token.authorize!(current_user)
        callback_url  = @token.oob? ? @token.client_application.callback_url : @token.callback_url
        @redirect_url = URI.parse(callback_url) unless callback_url.blank?

        unless @redirect_url.to_s.blank?
          @redirect_url.query = @redirect_url.query.blank? ?
              "oauth_token=#{@token.token}&oauth_verifier=#{@token.verifier}" :
              @redirect_url.query + "&oauth_token=#{@token.token}&oauth_verifier=#{@token.verifier}"

          # sign out current user
          sign_out

          redirect_to @redirect_url.to_s
        else
          render :action => "authorize_success"
        end
      else
        @token.invalidate!
        render :action => "authorize_failure"
      end
    else
      render :action => "authorize_failure"
    end
  end

  # Override this to match your authorization page form
  # It currently expects a checkbox called authorize
  def user_authorizes_token?
     true
  end

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
