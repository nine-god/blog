require 'base64'
class Photo < ApplicationRecord
	attr_accessor :file
	attr_accessor :request
	attr_accessor :source_data

	belongs_to :user

	validate :before_create, on: :create
	validates :name, presence: true
	validates :data, presence: true
	after_save :create_file

	def before_create
		file_name = File.basename(file.path)
		mini_image = Blog::PhotoMagick.mini(file)
		file_data = File.read(mini_image.path)

		self.data = Base64.encode64(file_data)
		self.name = "http://#{request.host_with_port}/photo/"+ file_name
	end

	def create_file
		source_data = Base64.decode64(data) if source_data.blank?
		file_path = "#{Rails.root}/public/photo/" + File.basename(name)
		photo_file = File.new(file_path, "w")
        photo_file.syswrite(source_data)
        photo_file.close

    	begin
			#尝试向nginx 静态文件目录复制文件
			image_file = File.new("#{Rails.root}/public/nginx_photo/"+File.basename(name), "w")
			image_file.syswrite(source_data)
			image_file.close
		rescue Exception => e
		end

		self.source_data =source_data
		
	end
end
