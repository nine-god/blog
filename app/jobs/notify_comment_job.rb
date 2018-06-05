class NotifyCommentJob < ApplicationJob
  queue_as :notifications

  def perform(comment_id)
    # 稍后做些事情
    Comment.notify_comment_created(comment_id)
  end
end