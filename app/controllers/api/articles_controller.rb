class Api::ArticlesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :delete]

  def index
    respond_with :api, Article.all
  end

  def show
    respond_with :api, Article.find(params[:id])
  end

  def create
    respond_with :api, Article.create(article_params.merge(user_id: current_user.id))
  end

  def update
    respond_with :api, Article.find(params[:id])
                              .update(article_params) # TODO: add cancancan
                                                     # e.g. if current_user.can? :update, Article
  end

  def destroy
    respond_with :api, Article.destroy(params[:id]) # TODO: cancancan
  end

  private
    def article_params
      params.require(:article).permit(:title, :content)
    end

end
