class UserMailer < ApplicationMailer
  def confirmation_instructions(user_id)
    user = User.find_by_id(user_id)
    @user_id = user_id
    @email = user.email
    @token = user.confirmation_token
    user.confirmation_sent_at = Time.now
    user.save
    mail(to: user.email, subject: '九神小屋 帐号激活')
  end
  def reset_password_instructions(user_id)
    user = User.find_by_id(user_id)
    user.create_reset_password_token

    @user_id = user_id
    @email = user.email
    @token = user.reset_password_token
    user.reset_password_sent_at = Time.now
    user.save
    mail(to: user.email, subject: '九神小屋 重置密码')
  end
end
