class Api::ArticlesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy]

  def index
    respond_with Article.all
  end

  def user_articles
    respond_with Article.where user_id: params[:id]
  end

  def show
    respond_with Article.find(params[:id])
  end

  def create
    respond_with :api, Article.create(article_params.merge(user_id: current_user.id))
  end

  def update
    article = Article.find(params[:id])
    authorize! :update, article
    respond_with :api, article.update(article_params)
  rescue CanCan::AccessDenied => e
    render json: { error: e }, status: 401
  end

  def destroy
    article = Article.find(params[:id])
    authorize! :delete, article
    respond_with :api, article.destroy
  rescue CanCan::AccessDenied => e
    render json: { error: e }, status: 401
  end

  private
    def article_params
      params.require(:article).permit(:title, :content)
    end

end
