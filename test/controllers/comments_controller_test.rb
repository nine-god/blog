require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @article1 = articles(:article1)
    @user1_article1_comment = comments(:user1_article1_comment)
    @user2_article1_comment = comments(:user2_article1_comment)
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

  test "should create" do
    #登录用户1
    post session_url(user: @user1_info)
    assert_difference('Comment.count') do
      post article_comments_url(@article1), params: { comment: { body: @user1_article1_comment.body } }
    end
    assert_equal @user1.id , Comment.last.user_id
    assert_redirected_to article_path(@article1), notice: '评论添加成功！'
  end

  test "should destroy" do
    #登录用户1
    post session_url(user: @user1_info)
    delete article_comment_url(@article1,@user1_article1_comment)
    assert_redirected_to article_path(@article1), notice: '评论已删除！'

    #登录管理员
    post session_url(user: @user1_info)
    delete article_comment_url(@article1,@user2_article1_comment)
    assert_redirected_to article_path(@article1), notice: '评论已删除！'
  end

  test "exception can not  create" do
    #没有用户登录时。不能创建
    assert_no_difference('Comment.count') do
      post article_comments_url(@article1), params: { comment: { body: @user1_article1_comment.body } }
    end
    assert_redirected_to new_user_session_path
    assert_equal '您没有登录，请先登录账号！',flash[:notice]

  end

  test "exception can not  destroy" do

    #没有用户登录时。不能删除
    assert_no_difference('Comment.count') do
      delete article_comment_url(@article1,@user1_article1_comment)
    end
    assert_redirected_to new_user_session_path
    assert_equal '您没有登录，请先登录账号！',flash[:notice]

    #登录用户2。不能删除
    post session_url(user: @user2_info)
    assert_no_difference('Comment.count') do
      delete article_comment_url(@article1,@user1_article1_comment)
    end
    assert_redirected_to  article_path(@article1), notice: '您不是作者,没有权限！'

  end
end
