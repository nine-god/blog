module Blog
	class PhotoMagick
		class << self
			def mini(tmp,max_size=1000)
			    mini_magick = MiniMagick::Image.open(tmp.path)		    
			    w,h = mini_magick[:width],mini_magick[:height] #=> [2048, 1536]		    
			    if w >max_size
			      mini_magick.resize "#{w*(max_size.to_f/w)}x#{h*(max_size.to_f/w)}"
			    end
			    w,h = mini_magick[:width],mini_magick[:height] #=> [2048, 1536]

			    if h > max_size
			      mini_magick.resize "#{w*(max_size.to_f/h)}x#{h*(max_size.to_f/h)}"
			    end
			    return mini_magick
		  	end
		end
	end
end