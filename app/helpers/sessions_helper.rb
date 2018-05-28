module SessionsHelper
	def user_signed_in?		
		session[:user_id] && User.find_by_id(session[:user_id])			
	end

	def current_user		
		User.find_by_id(session[:user_id])		
	end
end
