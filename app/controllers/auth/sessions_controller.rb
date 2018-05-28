module Auth
	class SessionsController < ApplicationController
	    before_action :authenticate_user!,only:[:destroy]
		def new
			@user = User.new
		end
		def create
			respond_to do |format|
				@user = User.authenticate(user_params) 
				if @user 
					sign_in(@user)					
					format.html { redirect_to root_url, notice: '登录成功！' }
				else
					format.html { redirect_to new_user_session_path, notice: '登录失败！' }
					
				end
			end
		end
		def destroy
			sign_out
			redirect_to root_path
		end
		private
	    def user_params
	      params.require(:user).permit(:username, :password)
	    end


	end
end