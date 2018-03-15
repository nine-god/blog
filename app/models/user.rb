class User < ApplicationRecord
  # Include default devise modules. Others available are:
  #  :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,:recoverable, :lockable,
  		 :rememberable, :trackable, :validatable , :confirmable
  has_many :articles

  validate :create_default_name 

  def create_default_name
  	# self.name = username if name.nil? || name==""
  end


end
