require 'test_helper'

class RolesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @role = roles(:guest)
    @no_user = roles(:no_user)
    @guest = users(:guest)
    @user = users(:user)
    @admin = users(:admin)
    @test = 'test'

    @guest_info = {
      username: @guest.username,
      email:@guest.email,
      password: @test,
      password_confirmation: @test
    }
    @user_info = {
      username: @user.username,
      email:@user.email,
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

  test "should get index" do
    #登录管理员
    post session_url(user: @admin_info)
    get roles_url
    assert_response :success
  end

  test "should get new" do
    #登录管理员
    post session_url(user: @admin_info)
    get new_role_url
    assert_response :success
  end

  test "should create role" do
    #登录管理员
    post session_url(user: @admin_info)
    assert_difference('Role.count') do
      post roles_url, params: { role: { admin: @role.admin, describe: @role.describe, name: @role.name, publish_articles: @role.publish_articles, publish_comments: @role.publish_comments } }
    end

    assert_redirected_to role_url(Role.last)
  end

  test "should show role" do
    #登录管理员
    post session_url(user: @admin_info)
    get role_url(@role)
    assert_response :success
  end

  test "should get edit" do
    #登录管理员
    post session_url(user: @admin_info)
    get edit_role_url(@role)
    assert_response :success
  end

  test "should update role" do
    #登录管理员
    post session_url(user: @admin_info)
    patch role_url(@role), params: { role: { admin: @role.admin, describe: @role.describe, name: @role.name, publish_articles: @role.publish_articles, publish_comments: @role.publish_comments } }
    assert_redirected_to role_url(@role)
  end

  test "should destroy role" do
    #登录管理员
    post session_url(user: @admin_info)
    #绑定了用户的role不能删除
    assert_no_difference('Role.count') do
      assert_raises do
        delete role_url(@role)
      end
    end
    assert_redirected_to root_path

    #登录管理员
    post session_url(user: @admin_info)
    #没有绑定用户的role可以删除
    assert_difference('Role.count',-1) do
        delete role_url(@no_user)
    end
    assert_redirected_to roles_url
  end

  #exception
  test "exception can not  get index" do

    #没有用户登录时，没有权限
    get roles_url
    assert_redirected_to new_user_session_path
    assert_equal '您没有登录，请先登录账号！',flash[:notice]

    #guest用户没有权限
    post session_url(user: @guest_info)
    get roles_url
    assert_redirected_to new_user_session_path
    assert_equal '您没有权限，请登录管理员账号！' , flash[:notice]

    #user用户没有权限
    post session_url(user: @user_info)
    get roles_url
    assert_redirected_to new_user_session_path
    assert_equal '您没有权限，请登录管理员账号！' , flash[:notice]
  end
test "exception can not get new" do
    #没有用户登录时，没有权限
    get new_role_url
    assert_redirected_to new_user_session_path
    assert_equal '您没有登录，请先登录账号！',flash[:notice]

    #guest用户没有权限
    post session_url(user: @guest_info)
    get new_role_url
    assert_redirected_to new_user_session_path
    assert_equal '您没有权限，请登录管理员账号！' , flash[:notice]

    #user用户没有权限
    post session_url(user: @user_info)
    get new_role_url
    assert_redirected_to new_user_session_path
    assert_equal '您没有权限，请登录管理员账号！' , flash[:notice]
  end

  test "exception can not create role" do
    #没有用户登录时，没有权限
    assert_no_difference('Role.count') do
      post roles_url, params: { role: { admin: @role.admin, describe: @role.describe, name: @role.name, publish_articles: @role.publish_articles, publish_comments: @role.publish_comments } }
    end
    assert_redirected_to new_user_session_path
    assert_equal '您没有登录，请先登录账号！',flash[:notice]

    #guest用户没有权限
    post session_url(user: @guest_info)
    assert_no_difference('Role.count') do
      post roles_url, params: { role: { admin: @role.admin, describe: @role.describe, name: @role.name, publish_articles: @role.publish_articles, publish_comments: @role.publish_comments } }
    end
    assert_redirected_to new_user_session_path
    assert_equal '您没有权限，请登录管理员账号！' , flash[:notice]

    #user用户没有权限
    post session_url(user: @user_info)
    assert_no_difference('Role.count') do
      post roles_url, params: { role: { admin: @role.admin, describe: @role.describe, name: @role.name, publish_articles: @role.publish_articles, publish_comments: @role.publish_comments } }
    end
    assert_redirected_to new_user_session_path
    assert_equal '您没有权限，请登录管理员账号！' , flash[:notice]

  end

  test "exception can not show role" do
    #没有用户登录时，没有权限
    get role_url(@role)
    assert_redirected_to new_user_session_path
    assert_equal '您没有登录，请先登录账号！',flash[:notice]

    #guest用户没有权限
    post session_url(user: @guest_info)
    get role_url(@role)
    assert_redirected_to new_user_session_path
    assert_equal '您没有权限，请登录管理员账号！' , flash[:notice]

    #user用户没有权限
    post session_url(user: @user_info)
    get role_url(@role)
    assert_redirected_to new_user_session_path
    assert_equal '您没有权限，请登录管理员账号！' , flash[:notice]
  end

  test "exception can not get edit" do

    #没有用户登录时，没有权限
    get edit_role_url(@role)
    assert_redirected_to new_user_session_path
    assert_equal '您没有登录，请先登录账号！',flash[:notice]

    #guest用户没有权限
    post session_url(user: @guest_info)
    get edit_role_url(@role)
    assert_redirected_to new_user_session_path
    assert_equal '您没有权限，请登录管理员账号！' , flash[:notice]

    #user用户没有权限
    post session_url(user: @user_info)
    get edit_role_url(@role)
    assert_redirected_to new_user_session_path
    assert_equal '您没有权限，请登录管理员账号！' , flash[:notice]
  end

  test "exception can not update role" do
    #没有用户登录时，没有权限
    patch role_url(@role), params: { role: { admin: @role.admin, describe: @role.describe, name: @role.name, publish_articles: @role.publish_articles, publish_comments: @role.publish_comments } }
    assert_redirected_to new_user_session_path
    assert_equal '您没有登录，请先登录账号！',flash[:notice]

    #guest用户没有权限
    post session_url(user: @guest_info)
    patch role_url(@role), params: { role: { admin: @role.admin, describe: @role.describe, name: @role.name, publish_articles: @role.publish_articles, publish_comments: @role.publish_comments } }
    assert_redirected_to new_user_session_path
    assert_equal '您没有权限，请登录管理员账号！' , flash[:notice]

    #user用户没有权限
    post session_url(user: @user_info)
    patch role_url(@role), params: { role: { admin: @role.admin, describe: @role.describe, name: @role.name, publish_articles: @role.publish_articles, publish_comments: @role.publish_comments } }
    assert_redirected_to new_user_session_path
    assert_equal '您没有权限，请登录管理员账号！' , flash[:notice]
  end

  test "exception can not  destroy role" do
    #没有用户登录时，没有权限
    delete role_url(@role)
    assert_redirected_to new_user_session_path
    assert_equal '您没有登录，请先登录账号！',flash[:notice]

    #guest用户没有权限
    post session_url(user: @guest_info)
    delete role_url(@role)
    assert_redirected_to new_user_session_path
    assert_equal '您没有权限，请登录管理员账号！' , flash[:notice]

    #user用户没有权限
    post session_url(user: @user_info)
    delete role_url(@role)
    assert_redirected_to new_user_session_path
    assert_equal '您没有权限，请登录管理员账号！' , flash[:notice]
  end
end
