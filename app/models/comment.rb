class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :article
  after_find :check_delete_flag
  def user
  	self.user = User.find(self.user_id)
  end

  def user_name
  	user.name
  end
  private
  def check_delete_flag
  	self.body  =  delete_flag ? "该评论已删除！" : body
  end

end
