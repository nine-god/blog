class Role < ApplicationRecord
  has_many :users
	def self.guest_role
		self.find_by_name('guest')
	end

	def self.user_role
		self.find_by_name('user')
	end
	def self.admin_role
		self.find_by_name('admin')
	end
end
