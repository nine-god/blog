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
  before_save :binding_role
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

  def admin?
    Role.admin_role.id == self.role_id
  end

  def publish_articles_admin?
    Role.find(self.role_id).publish_articles
  end
  private 
  def password_must_be_present
    errors.add(:password, "cannot null") unless encrypted_password.present?
  end

  def create_default_name
    self.name = username  if self.name.blank? 
  end
  def binding_role
    self.role_id = Role.admin_role.id if self.role_id.nil? && User.first.nil? 
    self.role_id = Role.guest_role.id if self.role_id.nil?
  end

end
