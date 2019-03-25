module Oauth
	class Http
		class << self
			def request(host_url,params={})
			   	uri = URI(host_url)
				uri.query = URI.encode_www_form(params)

				res = Net::HTTP.get_response(uri)
				case true
				when res.class == Net::HTTPMovedPermanently , res.class == Net::HTTPFound
				p "地址已重定向:"+res['location']
				redirect_uri = URI(res['location'])
				res = Net::HTTP.get_response(redirect_uri) 
				when res.class == Net::HTTPSuccess ,res.class == Net::HTTPOK
				when res.class == Net::HTTPForbidden
					res.each{|key,value|
					  p key + "  :  " + value
					}
				end
				# access_token=FC6C75D4191A8BA018731B2C410ACCC7&expires_in=7776000&refresh_token=1849877D8058B28A63D2CE38733098EC
				
				return res
			end

		end
	end
end