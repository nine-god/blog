require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @guest = users(:guest)
  end

  test "should new" do
    get users_sign_up_url()
    assert_response :success
  end

  test "should create" do
    user={
      username: "test_guest1",
      email:"test_guest1@qq.com",
      password: 'test_guest1',
      password_confirmation: 'test_guest1'
    }
    post users_url(user: user)
    assert_response :redirect
    assert_not_nil  session[:user_id]
    assert_not_nil  cookies[:user_id]
    assert_equal  User.find(session[:user_id]).role.name,'guest'
    assert_equal flash["notice"],"用户注册成功！"
  end

  test "should show" do
    get user_url(@guest)
    assert_response :success
  end





  test "should edit" do
    user={
      username: "test_guest1",
      email:"test_guest1@qq.com",
      password: 'test_guest1',
      password_confirmation: 'test_guest1'
    }
    post users_url(user: user)
    @user = User.find_by_name('test_guest1')
    post session_url(user: user)
    get edit_user_url(@user)
    assert_response :success
  end

  test "should update" do
    user={
      username: "test_guest1",
      email:"test_guest1@qq.com",
      password: 'test_guest1',
      password_confirmation: 'test_guest1'
    }
    post users_url(user: user)
    @user = User.find_by_name('test_guest1')
    post session_url(user: user)
    patch user_path(id:@user.id,user:user)
    assert_redirected_to user_path(@user)
  end
  #exception
  test "exception edit user" do
    get edit_user_url(@guest)
    assert_redirected_to new_user_session_url
  end

end
