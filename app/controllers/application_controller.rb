class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception
	before_action do 
		session[:user_id] ||= cookies.signed[:user_id]		
	end

	private

	include SessionsHelper

	def authenticate_user!
		redirect_to new_user_session_path unless user_signed_in?
	end

	def sign_in(user)		
		session[:user_id] = user.id 
		cookies.signed[:user_id] = user.id		
	end

	def sign_out
		session.delete(:user_id)		
		cookies.delete(:user_id)		
	end
	# heper_method :current_user
end