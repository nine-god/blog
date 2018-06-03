class NotificationsController < ApplicationController
  def index
    @notifications = notifications.order("created_at desc")
  end

  def clean
    notifications.delete_all
    redirect_to notifications_index_path
  end

  private

  def notifications
    # current_user.notifications
    Notification.where(user_id: current_user.id)
  end
end
