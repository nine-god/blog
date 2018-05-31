require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
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
    post session_url(user: @guest_info)
    get edit_user_url(@guest)
    assert_response :success
  end

  test "should update" do
    post session_url(user: @guest_info)
    patch user_path(id:@guest.id,user:@guest_info)
    assert_redirected_to user_path(@guest)
  end

  #exception
  #没有登录，不能打开用户资料编辑页面
  test "exception edit user with no sign_in" do
    get edit_user_url(@guest)
    assert_redirected_to new_user_session_url
  end

  #exception
  #非用户本人，不可打开用户资料编辑页面，管理员可以
  test "exception other cant not edit username" do
    #登录用户1,更新用户2资料
    post session_url(user: @user1_info)

    get edit_user_url(@user2)
    assert_redirected_to root_path
    assert_equal '您没有权限！' , flash[:notice]

    #登录管理员账号
    post session_url(user: @admin_info)
    get edit_user_url(@user2)
    assert_response :success
  end

  #exception
  #用户更新资料时，不可更改用户名
  test "exception cant not edit username and can edit other " do
    user={
      username: "test_guest1",
      email:"test_guest1@qq.com",
      password: 'test_guest1',
      password_confirmation: 'test_guest1'
    }
    post users_url(user: user)
    @user = User.find_by_username(user[:username])
    post session_url(user: user)
    old_password = @user.encrypted_password
    user2={
      username: "test_guest12",
      email:"test_guest12@qq.com",
      password: 'test_guest12',
      password_confirmation: 'test_guest12'
    }

    patch user_path(id:@user.id,user:user2)
    assert_redirected_to user_path(@user)

    @user.reload

    assert_equal user[:username] , @user.username
    assert_equal user2[:email] , @user.email
    assert_not_equal old_password , @user.encrypted_password
  end



  #exception
  #其他用户不能修改非本人资料
  test "exception other can not edit another user" do
    #登录用户1
    post session_url(user: @user1_info)


    #用户1 更新用户2的资料
    old_password = @user2.encrypted_password
    patch user_path(id:@user2.id,user:@user2_info)
    assert_redirected_to root_path
    assert_equal '您没有权限！' , flash[:notice]
    @user2.reload

    assert_equal @user2_info[:username] , @user2.username
    assert_equal @user2_info[:email] , @user2.email
    assert_equal old_password , @user2.encrypted_password
  end

  #exception
  #管理员可以修改其他用户资料
  test "exception admin can edit other " do
    #登录管理员账号
    post session_url(user: @admin_info)

    #管理员更新用户2的资料
    user3={
      username: "test_guest3",
      email:"test_guest3@qq.com",
      password: 'test_guest3',
      password_confirmation: 'test_guest3'
    }
    old_password = @user2.encrypted_password
    patch user_path(id:@user2.id,user:user3)
    assert_redirected_to  user_path(@user2)
    assert_equal '用户资料修改成功!' , flash[:notice]
    @user2.reload

    assert_equal @user2_info[:username] , @user2.username
    assert_equal user3[:email] , @user2.email
    assert_not_equal old_password , @user2.encrypted_password
  end

end
