module Auth
  class OmniauthCallbacksController < ApplicationController

    # provides_callback_for :qq
    def authoriz
      client_id = '101474979'
      client_secret = '473902fd7c1dfeb9db7de8851c952882'
      redirect_uri = "http://192.168.1.104/auth/omniauth_callbacks/qq"
      # p params["format"]
      uri = URI('https://graph.qq.com/oauth2.0/authorize')
      params = { 
        response_type: "code",
        client_id: client_id ,
        redirect_uri: redirect_uri,
        state: "login"
      }
      uri.query = URI.encode_www_form(params)


      redirect_to uri.to_s
    end
    def qq

      # "code"=>"BF1BD1B324584A27D7B1835EE6F0A06A", "state"=>"login"
      client_id = '101474979'
      client_secret = '473902fd7c1dfeb9db7de8851c952882'
      redirect_uri = "http://192.168.1.104/auth/omniauth_callbacks/qq"
      code = params[:code]
      state = params[:state]
      obj_qq = Oauth::Qq.new
      p user_info = obj_qq.require(code:code,client_id: client_id,client_secret:client_secret,redirect_uri:redirect_uri)
      p "1"*88
     
      @user = User.find_or_create_by(
          provider: 'qq',
          uid:user_info["openid"],
          username: 'qq_'+user_info["openid"]
         )
      # @user =User.find_by_username('qq_'+user_info["openid"])
      @user.update(
          name:user_info["nickname"]
         )
      if @user.persisted?
        sign_in(@user)
        redirect_to root_path
      else   
        puts @user.errors.full_messages
             
        # redirect_to users_sign_up_path
        redirect_to new_user_session_path
      end
    rescue
      redirect_to new_user_session_path
    end

    def failure
      redirect_to root_path
    end
  end
end