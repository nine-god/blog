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
  #没有登录，不能打开用户资料编辑页面
  test "exception edit user with no sign_in" do
    get edit_user_url(@guest)
    assert_redirected_to new_user_session_url
  end

  #exception
  #非用户本人，不可打开用户资料编辑页面，管理员可以
  test "exception other cant not edit username" do
    #注册用户1
    user1={
      username: "test_guest1",
      email:"test_guest1@qq.com",
      password: 'test_guest1',
      password_confirmation: 'test_guest1'
    }
    post users_url(user: user1)

    #注册用户2
    user2={
      username: "test_guest12",
      email:"test_guest12@qq.com",
      password: 'test_guest12',
      password_confirmation: 'test_guest12'
    }
    post users_url(user: user2)

    #登录用户1
    @user1 = User.find_by_username(user1[:username])
    post session_url(user: user1)

    @user2 = User.find_by_username(user2[:username])
    get edit_user_url(@user2)
    assert_redirected_to root_path
    assert_equal '您没有权限！' , flash[:notice]

    #修改用户1为管理员
    @user1 = User.find_by_username(user1[:username])
    @user1.update(role_id:Role.admin_role.id)


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
    #注册用户1
    user1={
      username: "test_guest1",
      email:"test_guest1@qq.com",
      password: 'test_guest1',
      password_confirmation: 'test_guest1'
    }
    post users_url(user: user1)

    #注册用户2
    user2={
      username: "test_guest12",
      email:"test_guest12@qq.com",
      password: 'test_guest12',
      password_confirmation: 'test_guest12'
    }
    post users_url(user: user2)

    #登录用户1
    @user1 = User.find_by_username(user1[:username])
    post session_url(user: user1)


    #用户1 更新用户2的资料
    @user2 = User.find_by_username(user2[:username])
    old_password = @user2.encrypted_password
    patch user_path(id:@user2.id,user:user2)
    assert_redirected_to root_path
    assert_equal '您没有权限！' , flash[:notice]
    @user2.reload

    assert_equal user2[:username] , @user2.username
    assert_equal user2[:email] , @user2.email
    assert_equal old_password , @user2.encrypted_password
  end

  #exception
  #管理员可以修改其他用户资料
  test "exception admin can edit other " do
    #注册用户1
    user1={
      username: "test_guest1",
      email:"test_guest1@qq.com",
      password: 'test_guest1',
      password_confirmation: 'test_guest1'
    }
    post users_url(user: user1)

    #修改用户1为管理员
    @user1 = User.find_by_username(user1[:username])
    @user1.update(role_id:Role.admin_role.id)

    #注册用户2
    user2={
      username: "test_guest12",
      email:"test_guest12@qq.com",
      password: 'test_guest12',
      password_confirmation: 'test_guest12'
    }
    post users_url(user: user2)

    #登录用户1
    @user1 = User.find_by_username(user1[:username])
    post session_url(user: user1)


    #用户1 更新用户2的资料
    user3={
      username: "test_guest3",
      email:"test_guest3@qq.com",
      password: 'test_guest3',
      password_confirmation: 'test_guest3'
    }
    @user2 = User.find_by_username(user2[:username])
    old_password = @user2.encrypted_password
    patch user_path(id:@user2.id,user:user3)
    assert_redirected_to  user_path(@user2)
    assert_equal '用户资料修改成功!' , flash[:notice]
    @user2.reload

    assert_equal user2[:username] , @user2.username
    assert_equal user3[:email] , @user2.email
    assert_not_equal old_password , @user2.encrypted_password
  end

end
