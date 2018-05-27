require 'digest/sha2'
class User < ApplicationRecord
  attr_reader :password
  attr_accessor :password_confirmation

  has_many :articles
  has_many :photos
  has_many :dmusers

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true , if: :with_provider?
  validates :password, :confirmation => true 

  validate :password_must_be_present , if: :with_provider?
  validate :create_default_name 
  def with_provider?
    self.provider.blank?
  end

  def password=(password)
    @password = password
    if password.present?
      self.encrypted_password = self.class.hashed_password(password)
    end
  end
  
  def self.hashed_password(password)
    Digest::SHA2.hexdigest(password)    
  end

  def self.authenticate(args={})
      if user = find_by_username(args[:username])
        if user.encrypted_password == hashed_password(args[:password])
          user
        end
      end
  end
  # def User.from_omniauth(auth)
  #   where(email: auth["openid"], username: auth["openid"]).first_or_create do |user|
  #     user.email = auth["openid"]
  #     user.password = Devise.friendly_token[0,20]
  #     user.password_confirmation = user.password
  #     user.name = auth["nickname"]   # assuming the user model has a name
  #     user.username = auth["openid"]
      
  #     # If you are using confirmable and the provider(s) you use validate emails, 
  #     # uncomment the line below to skip the confirmation emails.
  #     user.skip_confirmation!
  #   end
  # end
  private 
  def password_must_be_present
    errors.add(:password, "cannot null") unless encrypted_password.present?
  end

  def create_default_name
    self.name = username  if self.name.blank? 
  end

end
