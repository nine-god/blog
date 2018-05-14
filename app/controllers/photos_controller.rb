class PhotosController < ApplicationController
	before_action :authenticate_user!,except: [:show]

	def create 		
	    @photo = Photo.new(
	    	file:params[:file].tempfile,
	    	user_id:current_user.id,
	    	request: request
	    	)
		if @photo.save
			render json: { ok: true, url: @photo.name }
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
			source_data = photo.source_data
	    end
	    send_data( source_data, :filename => filename )
	end
end
