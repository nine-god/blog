class Notification < ApplicationRecord
  belongs_to :user
  def actor_name
    User.find_by_id(actor_id).name
  end

  def target
    eval(target_type).find_by_id(target_id)
  end
  def second_target
    eval(second_target_type).find(second_target_id)
  end
  def read?
    !read_at.blank?
  end
end
