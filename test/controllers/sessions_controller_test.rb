require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @guest = users(:guest)
  end

  test "should new" do
    get new_user_session_url
    assert_response :success
  end

  test "should create" do
    user={
      username: "guest",
      password: 'admin123'
    }
    post session_url(user: user)
    assert_response :redirect
    assert_equal  session[:user_id] , @guest.id
    assert_equal flash["notice"],"登录成功！"
  end

  test "should destroy" do
    user={
      username: "guest",
      password: 'admin123'
    }
    post session_url(user: user)
    delete destroy_user_session_url()
    assert_response :redirect
    assert_nil  session[:user_id]
    assert_equal "用户已正常退出！",flash["notice"]
  end

  #exception
  test "sign_out no user" do
    delete destroy_user_session_url()
    assert_response :redirect
    assert_nil  session[:user_id]
    assert_equal "您没有登录，请先登录账号！",flash["notice"]
  end
end
