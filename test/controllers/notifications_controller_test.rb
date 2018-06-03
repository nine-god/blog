require 'test_helper'

class NotificationsControllerTest < ActionDispatch::IntegrationTest
  setup do

    @guest = users(:guest)
    @user1 = users(:user1)
    @user2 = users(:user2)
    @admin = users(:admin)
    @test = 'test'

    @guest_info = {
      username: @guest.username,
      email:@guest.email,
      password: @test,
      password_confirmation: @test
    }
    @user1_info = {
      username: @user1.username,
      email:@user1.email,
      password: @test,
      password_confirmation: @test
    }
    @user2_info = {
      username: @user2.username,
      email:@user2.email,
      password: @test,
      password_confirmation: @test
    }
    @admin_info = {
      username: @admin.username,
      email:@admin.email,
      password: @test,
      password_confirmation: @test
    }
    @article1 = articles(:article1)
    @user2_article1_comment = comments(:user2_article1_comment)
    @notification = notifications(:user1)
    @notification.update(
      actor_id:@user2.id,
      target_type: "Article",
      target_id:@article1.id,
      second_target_type: "Comment",
      second_target_id:@user2_article1_comment.id
      )


  end
  test "should get index" do
    #登录用户1
    post session_url(user: @user1_info)
    get notifications_index_url
    assert_response :success
  end
  test "should clean all" do
    #登录用户1
    post session_url(user: @user1_info)
    delete notifications_clean_path
    assert_redirected_to  notifications_index_path
  end

  #exception
  test "exception no login can not get index" do
    get notifications_index_url
    assert_redirected_to new_user_session_path
    assert_equal '您没有登录，请先登录账号！',flash[:notice]
  end
  #exception
  test "exception no login can not clean" do
    get notifications_index_url
    delete notifications_clean_path
    assert_equal '您没有登录，请先登录账号！',flash[:notice]
  end
end
