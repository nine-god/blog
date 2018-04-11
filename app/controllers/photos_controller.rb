require 'base64'
class PhotosController < ApplicationController
	before_action :authenticate_user!,except: [:show]
	def create
		
		tempfile = params[:file].tempfile
		file_name = File.basename(tempfile.path)
		file_path = "#{Rails.root}/public/photo/" + file_name
		mini_image = create_mini_image(tempfile)
		data = File.read(mini_image.path)
		base64_data = Base64.encode64(data)
		if base64_data.blank?
	      render json: { ok: false }, status: 400
	      return
	    end

		@photo = Photo.new
		@photo.data =  Base64.encode64(data)

	    photo_url = "http://#{request.host_with_port}/photo/"+ file_name
		@photo.name = photo_url
		@photo.user_id = current_user.id
		if @photo.save
			photo_file = File.new(file_path, "w")
	        photo_file.syswrite(data)
	        photo_file.close
			render json: { ok: true, url: photo_url }
		else
			render json: { ok: false }
		end
	end
	def show
		filename = "#{params[:name]}.png"
	    file_dir = "#{Rails.root}/public/photo/"
	    file_path = file_dir + filename
	    if File::exist?( file_path)
	      source_data = File.read(file_path)
	    else
	    	photo_url = "http://#{request.host_with_port}/photo/"+filename
			photo = Photo.where(name: photo_url).first
			source_data = Base64.decode64(photo.data)
			image_file = File.new(file_path, "w")
			image_file.syswrite(source_data)
			image_file.close
			begin
				#尝试向nginx 静态文件目录复制文件
				image_file = File.new("#{Rails.root}/public/nginx_photo/"+filename, "w")
				image_file.syswrite(source_data)
				image_file.close
			rescue Exception => e
			end
	    end
	    send_data( source_data, :filename => filename )
	end

	private
		def create_mini_image(tmp)
		    mini_magick = MiniMagick::Image.open(tmp.path)
		    mini_magick.path
		    w,h = mini_magick[:width],mini_magick[:height] #=> [2048, 1536]
		    max_size = 1000
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
