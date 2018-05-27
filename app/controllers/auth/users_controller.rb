module Auth
	class UsersController < ApplicationController
		before_action :set_user, only: [:show, :edit, :update]
	    before_action :authenticate_user!,except: [:new,:create,:show]
	    def new
	    	@user = User.new
	    end
	    def create
			@user = User.new(user_params)
		    respond_to do |format|
		      if @user.save
		      	sign_in(@user)		      	
		        format.html { redirect_to user_path(@user), notice: 'Article was successfully created.' }
		      else
		      	format.html { render :new }

		      end
		    end
	    end
		def show 
		end

		def edit
		end

		def update
			respond_to do |format|
			if @user.update(user_params)
				format.html { redirect_to user_path(@user), notice: 'User was successfully updated.' }
			else
				format.html { render :edit }
			end
			end
		end
		private
		# Use callbacks to share common setup or constraints between actions.
		def set_user
			@user = User.find_by_id(params[:id])
		end

		# Never trust parameters from the scary internet, only allow the white list through.
		def user_params			
			params.require(:user).permit(:username,:email,:password,:password_confirmation, :name,:profile)
		end
	end
end