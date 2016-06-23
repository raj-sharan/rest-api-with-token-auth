class ApplicationController < ActionController::API
	protect_from_forgery

	before_filter :authenticate!

	rescue_from ActiveRecord::RecordNotFound,       with: :not_found
  	rescue_from ActionController::ParameterMissing, with: :missing_param_error


	private:

	def not_found
    	render status: :not_found, json: ''
  	end

  	def missing_param_error(exception)
    	render status: :unprocessable_entity, json: { error: exception.message }
 	end

	def authenticate!
		authenticate_or_request_with_http_token do |token, options|
    		User.authenticate_token(token)
    	end
    end
end
