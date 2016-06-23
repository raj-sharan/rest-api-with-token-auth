class Api::V1::EventsController < ApplicationController
	respond_to :json

	def index
    	@events = Event.all
    	respond_with @events
  	end
end
