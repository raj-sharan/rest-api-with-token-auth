class SessionController < ApplicationController

  skip_before_action :authenticate!, only: [:create]

  def create
    user = User.find_by(email: email_from_headers)
    if user
      token = user.authenticate(password_from_header)
      	unless token
     	 render status: :unauthorized, json: ""
  		else
     	 render status: :ok, json: { user_email: user.email, auth_token: token }
  		end
    else
      render status: :unauthorized, json: ""
    end
  end

  def destroy
    User.expire_token(request)
    render status: :ok, json: ""
  end

  private

    def session_params
      params.require(:user).permit(:email, :password)
    end

    def email_from_headers
      request.header["X-User-Email"]
  	end

  	def password_from_header
  	  request.header["X-User-Password"]
  	end

end
