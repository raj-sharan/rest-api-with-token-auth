class AuthToken < ActiveRecord::Base
  belongs_to :user

  class << self
  	
  	def expire_token(requested_token)
    	AuthToken.delete(:token, requested_token) if AuthToken.exists?(:token, requested_token)
  	end

  	def validate_token(requested_token)
  		purge_old_tokens
    	auth_token = AuthToken.find_by(:token, requested_token)
    	return false unless auth_token.present? && auth_token.last_used_at < 1.hour.ago
    	auth_token.touch_token
  	end

  	def purge_old_tokens
    	AuthToken.where(["last_used_at > ?", 1.hour.ago]).destroy_all
  	end

  end

  def create_token
  	self.last_used_at = DateTime.current
  	generate_authentication_token
  end
  
  def generate_authentication_token
    loop do
    	self.token = SecureRandom.base64.tr('+/=', 'Qrt')
    	break unless User.exists?(token: token).any?
  	end
  end

  def touch_token
      self.update_attribute(:last_used_at, DateTime.current)
  end

end
