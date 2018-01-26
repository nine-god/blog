class User < ApplicationRecord
  # Include default devise modules. Others available are:
  #  and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable , :confirmable, :lockable , :timeoutable

  has_many :articles

  validate :create_default_name 

  def create_default_name
  	# self.name = username if name.nil? || name==""
  end


end
