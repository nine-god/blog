require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do

    @user_info={
      username: "test_guest1",
      email:"test_guest1@qq.com",
      password: 'test_guest1',
      password_confirmation: 'test_guest1'
    }
    post users_url(user: @user_info)
    delete destroy_user_session_url()
    @guest = User.find_by_username("test_guest1")
  end

  test "should new" do
    get new_user_session_url
    assert_response :success
  end

  test "should create" do
    user={
      username: @user_info[:username],
      password: @user_info[:password]
    }
    post session_url(user: user)
    assert_redirected_to root_url
    assert_equal  @guest.id,session[:user_id]
    assert_equal flash["notice"],"登录成功！"
  end

  test "should destroy" do
    user={
      username: @user_info[:username],
      password: @user_info[:password]
    }
    post session_url(user: user)
    delete destroy_user_session_url()
    assert_redirected_to root_url
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

  #exception
  test "sign_in username error" do
    user={
      username: @user_info[:username]+"1",
      password: @user_info[:password]
    }
    post session_url(user: user)
    assert_redirected_to new_user_session_path
    assert_nil  session[:user_id]
    assert_equal '登录失败！' , flash[:notice]
  end

  #exception
  test "sign_in password error" do
    user={
      username: @user_info[:username],
      password: @user_info[:password]+"1"
    }
    post session_url(user: user)
    assert_redirected_to new_user_session_path
    assert_nil  session[:user_id]
    assert_equal '登录失败！' , flash[:notice]
  end
end
