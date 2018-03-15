class AboutsController < ApplicationController
	def show 
		@users = User.all
	end
end