class User < ActiveRecord::Base
	has_many :auth_tokens , dependent: :destroy
	#has_secure_password
	before_create: digest_password

	def authenticate(password)
		return nil unless PasswordDigester.check?(password, self.password_digest)
		auth_token = AuthToken.new.create_token
		self.auth_tokens << auth_token
		auth_token.token
	end

	def self.expire_token(token)
		AuthToken.expire_token(token)
	end

	def self.authenticate_token(token)
		AuthToken.validate_token(token)
	end

  	def digest_password(password)
  		self.password_digest = PasswordDigester.encode(password)
  	end

end
