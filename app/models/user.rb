require 'digest/sha2'
class User < ApplicationRecord
  attr_reader :password
  attr_accessor :password_confirmation

  has_many :articles
  has_many :photos
  has_many :dmusers
  has_many :comments
  has_many :notifications
  belongs_to :role

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true , if: :with_provider?
  validates :password, :confirmation => true

  validate :password_must_be_present , if: :with_provider?
  validate :create_default_name
  # validate :create_confirmation_token

  before_validation :binding_role
  before_create :create_confirmation_token
  def create_confirmation_token
    self.confirmation_token = Digest::SHA2.hexdigest(Time.now.to_s)
  end
  def create_reset_password_token
    self.reset_password_token = Digest::SHA2.hexdigest(Time.now.to_s)
  end
  after_create :async_create_confirmation_mailer, on: :create
  def async_create_confirmation_mailer
    #仅当用户通过email邮箱注册账号时，需要做邮箱确认验证
    UserMailer.confirmation_instructions(self.id).deliver_later if !email.blank? && provider.blank?
  end

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

  def role
    Role.find(self.role_id)
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
