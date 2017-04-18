class Api::CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy]

  def index
    article = Article.find params[:article_id]
    respond_with :api, article.comments
  end

  def show
    respond_with :api, Comment.find(params[:id])
  end

  def create
    respond_with :api, Comment.create(comment_params.merge(user_id:    current_user.id,
                                                           article_id: params[:article_id]))
  end

  def update
    comment = Comment.find params[:id]
    authorize! :update, comment
    respond_with :api, comment.update(comment_params)
  rescue CanCan::AccessDenied => e
    render json: { error: e }, status: 401
  end

  def destroy
    comment = Comment.find params[:id]
    authorize! :delete, comment
    respond_with :api, comment.destroy
  rescue CanCan::AccessDenied => e
    render json: { error: e }, status: 401
  end

  private
    def comment_params
      params.require(:comment).permit(:content)
    end
end
