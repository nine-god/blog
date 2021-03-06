class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!,except: [:index,:show]
  before_action :authenticate_admin!,except: [:index,:show,:preview]
  # GET /articles
  # GET /articles.json
  def index
    @offset = params[:offset] || 0
    @limit = params[:limit] || 10
    @total = Article.count
    @articles = Article.order("updated_at desc").offset(@offset).limit(@limit)
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
     @article.hits+=1
     @article.save(touch: false)
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(article_params)
    @article.user_id = current_user.id

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def preview
    @body = params[:body]

    respond_to do |format|
      format.json
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:title, :text)
    end

    def authenticate_admin!
      unless current_user.publish_articles_admin?
        redirect_to root_path , notice: '您没有权限！访客不能发表博文!'
        return
      end

      if params["action"]=="new"
        return
      end
      if request.request_method == "POST"
        return
      end
      #更新和删除，需要是作者或者是管理员
      if current_user.id != @article.user_id && !current_user.admin?
        redirect_to root_path , notice: '您不是作者,没有权限！'
        return
      end
    end
end
