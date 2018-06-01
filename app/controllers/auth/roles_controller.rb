module Auth
  class RolesController < ApplicationController
    before_action :set_role, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user!
    before_action :authenticate_admin!
    # GET /roles
    # GET /roles.json
    def index
      @offset = params[:offset] || 0
      @limit = params[:limit] || 10
      @total = Role.count
      @roles = Role.order("id desc").offset(@offset).limit(@limit)
    end

    # GET /roles/1
    # GET /roles/1.json
    def show
    end

    # GET /roles/new
    def new
      @role = Role.new
    end

    # GET /roles/1/edit
    def edit
    end

    # POST /roles
    # POST /roles.json
    def create
      @role = Role.new(role_params)

      respond_to do |format|
        if @role.save
          format.html { redirect_to @role, notice: 'Role was successfully created.' }
          format.json { render :show, status: :created, location: @role }
        else
          format.html { render :new }
          format.json { render json: @role.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /roles/1
    # PATCH/PUT /roles/1.json
    def update
      respond_to do |format|
        if @role.update(role_params)
          format.html { redirect_to @role, notice: 'Role was successfully updated.' }
          format.json { render :show, status: :ok, location: @role }
        else
          format.html { render :edit }
          format.json { render json: @role.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /roles/1
    # DELETE /roles/1.json
    def destroy
      @role.destroy
      respond_to do |format|
        format.html { redirect_to roles_url, notice: 'Role was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_role
        @role = Role.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def role_params
        params.require(:role).permit(:name, :describe, :admin, :publish_articles, :publish_comments)
      end

      def authenticate_admin!
        redirect_to new_user_session_path , notice: '您没有权限，请登录管理员账号！' unless current_user.admin?
      end
  end
end