module Auth
  class UsersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update,:confirmation]
    before_action :authenticate_user!,except: [:new,:create,:show,:confirmation,:new_password,:reset_password_mail,:edit_password,:reset_password]
    before_action :authenticate_admin!,except: [:new,:create,:show,:confirmation,:new_password,:reset_password_mail,:edit_password,:reset_password]
    def new
      @user = User.new
    end
    def index
      @offset = params[:offset] || 0
      @limit = params[:limit] || 10
      @total = User.count
      @users = User.order("role_id desc").offset(@offset).limit(@limit)
    end
    def create
      @user = User.new(user_params)
      respond_to do |format|
        if @user.save
          # sign_in(@user)
          format.html { redirect_to user_path(@user), notice: '请登录注册，邮箱激活账号，完成注册！' }
        else
          # p @user.errors
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
          format.html { redirect_to user_path(@user), notice: '用户资料修改成功!' }
        else
          format.html { render :edit }
        end
      end
    end


    def confirmation
      max_attempts = 5
      if @user.email.blank? ||  @user.confirmation_token.blank? || @user.confirmation_sent_at.blank? || !@user.confirmed_at.blank?
        redirect_to root_path ,  alert: "无效验证！"
        return
      end
      if @user.failed_attempts >= max_attempts
        @user.failed_attempts = 0
        @user.save
        redirect_to root_path ,  alert: "已达到最大验证次数，请重新登录邮箱，点击验证邮件中的链接验证账号！"
        UserMailer.confirmation_instructions(@user.id).deliver_later
        return
      end

      if @user.confirmation_token != params[:confirmation_token]
        @user.failed_attempts+=1
        @user.save
        redirect_to root_path ,  alert: "验证失败，剩余 #{ max_attempts - @user.failed_attempts} 次重试机会!"
        return
      end
      @user.confirmed_at = Time.now
      @user.save
      redirect_to new_user_session_path, notice: '邮箱验证成功！，请登录！'
    end
    def new_password
      @user = User.new
    end
    def reset_password_mail
      email = params[:user][:email]
      if email.blank?
        redirect_to new_password_users_path , alert: "邮箱不能为空！"
        return
      end

      user = User.find_by_email(email)
      unless user
        redirect_to new_password_users_path , alert: "无效邮箱！"
        return
      end

      UserMailer.reset_password_instructions(user.id).deliver_later
      redirect_to new_password_users_path, notice: '重置密码邮件已发送，请注意查收邮件！'
    end
    def edit_password
      @user = User.find_by_id(params[:id])
    end
    def reset_password
      id = params[:user][:id]
      reset_password_token = params[:user][:reset_password_token]

      password = params[:user][:password]
      password_confirmation = params[:user][:password_confirmation]
      @user = User.find_by_id(id)
      unless @user
        redirect_to root_path , alert: "非法请求!"
        return
      end

      if @user.reset_password_token != reset_password_token
        redirect_to root_path , alert: "无效请求!"
        return
      end

      if @user.update(user_params)
        redirect_to new_user_session_path, notice: '重置密码成功!'
      else
        render :edit_password
        # redirect_to edit_password_users_path(id:id, reset_password_token: reset_password_token),
      end
    end
    private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find_by_id(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      #用户名\邮箱创建后不可修改
      if  request.request_method == "POST"
        return params.require(:user).permit(:username,:email,:password,:password_confirmation, :name,:profile)
      end

      params.require(:user).permit(:password,:password_confirmation, :name,:profile)

    end

    def authenticate_admin!
      if params["action"] == "index"
        if current_user.admin?
          return
        else
          redirect_to root_path , notice: '您没有权限！'
          return
        end
      end
      #更新和删除，需要是作者或者是管理员
      if current_user.id != @user.id && !current_user.admin?
        redirect_to root_path , notice: '您没有权限！'
        return
      end
    end
  end
end