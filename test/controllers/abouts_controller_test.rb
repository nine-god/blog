require 'test_helper'

class AboutsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @about = abouts(:about)
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
  test "should get show" do
    get abouts_url
    assert_response :success
  end
  test "should get edit" do
    #登录管理员
    post session_url(user: @admin_info)
    get edit_abouts_url
    assert_response :success
  end
  test "should update about" do
    #登录管理员
    post session_url(user: @admin_info)
    patch abouts_url(about: { text: @about.text } )
    assert_redirected_to abouts_path()
  end

  #exception
  test "exception can not  get edit" do
    #没有用户登录时，没有权限
    get edit_abouts_url
    assert_redirected_to new_user_session_path
    assert_equal '您没有登录，请先登录账号！',flash[:notice]

    #guest用户没有权限
    post session_url(user: @guest_info)
    get edit_abouts_url
    assert_redirected_to new_user_session_path
    assert_equal '您没有权限，请登录管理员账号！' , flash[:notice]

    #user用户没有权限
    post session_url(user: @user_info)
    get edit_abouts_url
    assert_redirected_to new_user_session_path
    assert_equal '您没有权限，请登录管理员账号！' , flash[:notice]
  end
  test "exception can not update about" do

    #没有用户登录时，没有权限
    patch abouts_url(about: { text: @about.text } )
    assert_redirected_to new_user_session_path
    assert_equal '您没有登录，请先登录账号！',flash[:notice]

    #guest用户没有权限
    post session_url(user: @guest_info)
    patch abouts_url(about: { text: @about.text } )
    assert_redirected_to new_user_session_path
    assert_equal '您没有权限，请登录管理员账号！' , flash[:notice]

    #user用户没有权限
    post session_url(user: @user_info)
    patch abouts_url(about: { text: @about.text } )
    assert_redirected_to new_user_session_path
    assert_equal '您没有权限，请登录管理员账号！' , flash[:notice]
  end
end
