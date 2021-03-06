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
					if @user.confirmed_at.blank?
						format.html { redirect_to new_user_session_path, alert: '邮箱尚未验证，请先登录注册邮箱，点击验证邮件中的链接验证账号！' }
					else
						sign_in(@user)
						format.html { redirect_to root_url, notice: '登录成功！' }
					end
				else
					format.html { redirect_to new_user_session_path, alert: '登录失败！' }
				end
			end
		end
		def destroy
			sign_out
			redirect_to root_path,notice:"用户已正常退出！"
		end
		private
	    def user_params
	      params.require(:user).permit(:username, :password)
	    end


	end
end