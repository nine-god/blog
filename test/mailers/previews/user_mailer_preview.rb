class UserMailerPreview < ActionMailer::Preview
  def confirmation_instructions
    UserMailer.confirmation_instructions(User.last)
  end
end