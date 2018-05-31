require 'test_helper'

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @article = articles(:article1)

    @guest = users(:guest)
    @guest_info={
      username: @guest.username,
      password: 'test'
    }

    @user1 = users(:user1)
    @user1_info={
      username: @user1.username,
      password: 'test'
    }

    @user2 = users(:user2)
    @user2_info={
      username: @user2.username,
      password: 'test'
    }
    @admin = users(:admin)
    @admin_info={
      username: @admin.username,
      password: 'test'
    }
  end

  test "should get index" do
    get articles_url
    assert_response :success
  end

  test "should show article" do
    get article_url(@article)
    assert_response :success
  end

  test "should get new" do
    #用户可以打开新建博文页面
    post session_url(user: @user1_info)
    get new_article_url
    assert_response :success

    #管理员可以打开新建博文页面
    post session_url(user: @admin_info)
    get new_article_url
    assert_response :success
  end

  test "should get edit" do
    #作者可以打开编辑博文页面
    post session_url(user: @user1_info)
    get edit_article_url(@article)
    assert_response :success

    #管理员可以打开编辑博文页面
    post session_url(user: @admin_info)
    get edit_article_url(@article)
    assert_response :success
  end

  test "should create article" do
    #登录用户1
    post session_url(user: @user1_info)
    assert_difference('Article.count') do
      post articles_url, params: { article: { text: @article.text, title: @article.title, user_id: @article.user_id } }
    end

    assert_redirected_to article_url(Article.last)
    assert_equal @user1.id , Article.last.user_id

    #登录管理员
    post session_url(user: @admin_info)
    assert_difference('Article.count') do
      post articles_url, params: { article: { text: @article.text, title: @article.title, user_id: @admin.id } }
    end

    assert_redirected_to article_url(Article.last)
    assert_equal @admin.id , Article.last.user_id
  end





  test "should update article" do
    #登录用户1
    post session_url(user: @user1_info)
    patch article_url(@article), params: { article: { text: @article.text, title: @article.title, user_id: @article.user_id } }
    assert_redirected_to article_url(@article)
    assert_equal @user1.id , @article.reload.user_id

    #登录管理员
    post session_url(user: @admin_info)
    patch article_url(@article), params: { article: { text: @article.text, title: @article.title, user_id: @article.user_id } }
    assert_redirected_to article_url(@article)
    assert_equal @user1.id , @article.reload.user_id #管理员更新用户博文后，不会改变博文作者
  end

  test "user1 should destroy article" do
    #登录用户1
    post session_url(user: @user1_info)
    assert_difference('Article.count', -1) do
      delete article_url(@article)
    end

    assert_redirected_to articles_url
  end

  test "admin should destroy article" do
    #登录管理员
    post session_url(user: @admin_info)
    assert_difference('Article.count', -1) do
      delete article_url(@article)
    end

    assert_redirected_to articles_url
  end
  #打开新建博文页面异常
  test "exception show new article" do
    #没有用户登录，不能打开创建博文页面
    get new_article_url
    assert_redirected_to new_user_session_path
    assert_equal '您没有登录，请先登录账号！',flash[:notice]

    #访客不能打开创建博文页面
    post session_url(user: @guest_info)
    get new_article_url
    assert_redirected_to root_path
    assert_equal '您没有权限！访客不能发表博文!',flash[:notice]
  end

  #打开编辑博文页面异常
  test "exception show edit article" do
    #没有用户登录，不能打开编辑博文页面
    get edit_article_url(@article)
    assert_redirected_to new_user_session_path
    assert_equal '您没有登录，请先登录账号！',flash[:notice]

    #访客不能打开编辑博文页面
    post session_url(user: @guest_info)
    get edit_article_url(@article)
    assert_redirected_to root_path
    assert_equal '您没有权限！访客不能发表博文!',flash[:notice]

    #非作者不能打开编辑博文页面
    post session_url(user: @user2_info)
    get edit_article_url(@article)
    assert_redirected_to root_path
    assert_equal "您不是作者,没有权限！",flash[:notice]
  end

  #访客不能创建博文
  test "exception  guest can not  create article" do

    #没有登录，不能新建博文
    assert_no_difference('Article.count') do
      post articles_url, params: { article: { text: @article.text, title: @article.title, user_id: @article.user_id } }
    end
    assert_redirected_to new_user_session_path
    assert_equal '您没有登录，请先登录账号！',flash[:notice]

    #登录访客
    post session_url(user: @guest_info)
    assert_no_difference('Article.count') do
      post articles_url, params: { article: { text: @article.text, title: @article.title, user_id: @article.user_id } }
    end

    assert_redirected_to root_path
    assert_equal '您没有权限！访客不能发表博文!',flash[:notice]
  end

  #作者和管理员，不能更新博文
  test "exception can not  update article" do
    #没有登录，不能更新博文
    patch article_url(@article), params: { article: { text: @article.text, title: @article.title, user_id: @article.user_id } }
    assert_redirected_to new_user_session_path
    assert_equal '您没有登录，请先登录账号！',flash[:notice]
    assert_equal @user1.id , @article.reload.user_id

    #登录访客
    post session_url(user: @guest_info)
    patch article_url(@article), params: { article: { text: @article.text, title: @article.title, user_id: @article.user_id } }
    assert_redirected_to root_path
    assert_equal '您没有权限！访客不能发表博文!',flash[:notice]
    assert_equal @user1.id , @article.reload.user_id

    #登录用户2
    post session_url(user: @user2_info)
    patch article_url(@article), params: { article: { text: @article.text, title: @article.title, user_id: @article.user_id } }
    assert_redirected_to root_path
    assert_equal "您不是作者,没有权限！",flash[:notice]
    assert_equal @user1.id , @article.reload.user_id #管理员更新用户博文后，不会改变博文作者
  end

  #非作者和管理员，不能删除博文
  test "exception can not  destroy article" do
    assert_no_difference('Article.count') do
      delete article_url(@article)
    end

    assert_redirected_to new_user_session_path
    assert_equal '您没有登录，请先登录账号！',flash[:notice]

    #登录用户2
    post session_url(user: @user2_info)
    assert_no_difference('Article.count') do
      delete article_url(@article)
    end

    assert_redirected_to root_path
    assert_equal "您不是作者,没有权限！",flash[:notice]
  end

end#非作者和管理员，不能删除博文



