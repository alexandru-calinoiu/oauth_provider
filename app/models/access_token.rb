class AccessToken < OauthToken
  validates_presence_of :user, :secret
  before_create :set_authorized_at

  attr_accessible :user, :client_application

  # Implement this to return a hash or array of the capabilities the access token has
  # This is particularly useful if you have implemented user defined permissions.
  # def capabilities
  #   {:invalidate=>"/oauth/invalidate",:capabilities=>"/oauth/capabilities"}
  # end

  protected

  def set_authorized_at
    self.authorized_at = Time.now
  end
end
