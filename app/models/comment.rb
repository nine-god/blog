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


  after_commit :async_create_comment_notify, on: :create
  def async_create_comment_notify
    NotifyCommentJob.perform_later(id)
  end

  def self.notify_comment_created(comment_id)
    comment = Comment.find_by_id(comment_id)
    article = Article.find_by_id(comment.article_id)
    Notification.create(
      user_id:article.user_id,
      actor_id: comment.user_id,
      notify_type: "Comment",
      target_type:"Article",
      target_id: comment.article_id,
      second_target_type: "Comment",
      second_target_id: comment.id
      )
  end
  private
  def check_delete_flag
  	self.body  =  delete_flag ? "该评论已删除！" : body
  end

end
