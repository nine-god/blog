class CommentsController < ApplicationController
	before_action :set_comment, only: [:destroy]
	before_action :authenticate_user!
	before_action :authenticate_admin!,except: [:create]

  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.create(comment_params)
    redirect_to article_path(@article), notice: '评论添加成功！'
  end

  def destroy
    @comment.update(delete_flag: true)
    redirect_to article_path(@article), notice: '评论已删除！'
  end

  private

    def set_comment
	    @article = Article.find(params[:article_id])
	    @comment = @article.comments.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:body).merge({user_id: current_user.id})
    end

    def authenticate_admin!
      #更新和删除，需要是作者或者是管理员
      redirect_to article_path(@article) , notice: '您不是作者,没有权限！' if current_user.id != @comment.user_id && !current_user.admin?
    end
end
