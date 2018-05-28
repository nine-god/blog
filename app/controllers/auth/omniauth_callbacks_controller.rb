module Auth
  class OmniauthCallbacksController < ApplicationController

    # provides_callback_for :qq
    def authoriz
      client_id = ENV["QQ_APP_ID"] 
      client_secret = ENV["QQ_APP_KEY"]
      redirect_uri = "http://www.nine-god.com/auth/omniauth_callbacks/qq"
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
      client_id = ENV["QQ_APP_ID"] 
      client_secret = ENV["QQ_APP_KEY"]
      redirect_uri = "http://www.nine-god.com/auth/omniauth_callbacks/qq"
      code = params[:code]
      state = params[:state]
      obj_qq = Oauth::Qq.new
      user_info = obj_qq.require(code:code,client_id: client_id,client_secret:client_secret,redirect_uri:redirect_uri)
      
     
      @user = User.find_or_create_by(
          provider: 'qq',
          uid:user_info["openid"],
          username: 'qq_'+user_info["openid"]
         )

      @user.update(
          name:user_info["nickname"]
         )
      if @user.persisted?
        sign_in(@user)
        redirect_to root_path, notice: '登录成功！'
      else   
        logger.debug @user.errors.full_messages

        redirect_to new_user_session_path, notice: '登录失败，请尝试重新登录！！'
      end
    rescue Exception=>e
      logger.debug e
      logger.debug e.backtrace.join("\n")
      redirect_to new_user_session_path, notice: '登录失败，请尝试重新登录！！'
    end

  end
end