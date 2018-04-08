require 'base64'
class PhotosController < ApplicationController
	before_action :authenticate_user!,except: [:show]
	def create
		
		tempfile = params[:file].tempfile
		file_path = "#{Rails.root}/public/photo/" + File.basename(tempfile.path)
		data = tempfile.read
		if data.blank?
	      render json: { ok: false }, status: 400
	      return
	    end

		@photo = Photo.new
		@photo.data =  Base64.encode64(data)

	    photo_url = "http://#{request.host_with_port}/photo/"+ File.basename(tempfile.path)
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
			p photo = Photo.where(name: photo_url).first
			source_data = Base64.decode64(photo.data)
			image_file = File.new(file_path, "w")
			image_file.syswrite(source_data)
			image_file.close

	    end
	    send_data( source_data, :filename => filename )
	end
end
