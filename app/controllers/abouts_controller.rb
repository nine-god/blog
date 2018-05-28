class AboutsController < ApplicationController
	before_action :set_about, only: [:show, :edit, :update]
	before_action :authenticate_user!,except: [:show]
	before_action :authenticate_admin!,except: [:show]
	def show 
		@users = User.where(role_id: [Role.user_role.id ,Role.admin_role.id])
	end

	def edit
	end

	def update
	    respond_to do |format|
	      if @about.update(about_params)
	        format.html { redirect_to abouts_path, notice: 'About was successfully updated.' }
	      else
	        format.html { render :edit }
	      end
	    end
	end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_about
    	@about = About.first.nil? ? About.create(text: "") : About.first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def about_params
      params.require(:about).permit(:text)
    end
    def authenticate_admin!
      redirect_to root_path , notice: '您没有权限！' unless current_user.admin?
    end
end