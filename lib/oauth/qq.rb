require 'net/https'
require 'json'

module Oauth
  class Qq
    def require(args={})
      code = args[:code]
      client_id = args[:client_id]
      client_secret = args[:client_secret]
      redirect_uri = args[:redirect_uri]
      
      params = { 
        grant_type: "authorization_code",
        client_secret: client_secret, 
        client_id: client_id,
        code:code,
        redirect_uri: redirect_uri
      }

      res = Oauth::Http.request('https://graph.qq.com/oauth2.0/token',params)
      access_token = analyse(res.body)["access_token"]

      
      params = { 
        access_token: access_token
      }
      res = Oauth::Http.request('https://graph.qq.com/oauth2.0/me',params)
      
      openid = get_openid(res.body)

      params = { 
        access_token: access_token,
        openid:openid,
        oauth_consumer_key:client_id

      }
      res = Oauth::Http.request('https://graph.qq.com/user/get_user_info',params)
      
      user_info = JSON.parse(res.body)
      user_info['openid'] = openid
      user_info
    end
    def analyse(str)
      hash={}
      a = "access_token=F4060E3C6DDD97AA561532AFA42D408B&expires_in=7776000&refresh_token=8C8ACA5C18AE8B5BC264EC973BF8E0B4"
      str.split("&").each{|each_one|
        rs = each_one.split("=")
        hash[rs[0]] = rs[1]
      }
      hash
    
    end
    def get_openid(str)
      callback = str[/\{(.+)\}/i,1]
      hash={}
      callback.split(",").each{|each_one|
        rs = each_one.split(":")
        hash[rs[0].delete("\"")] = rs[1].delete("\"")
      }
      hash["openid"]
    end
  end
end