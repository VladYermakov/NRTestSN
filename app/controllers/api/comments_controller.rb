class Api::CommentsController < ApplicationBaseController
  def index
    respond_with :api, Comment.find_by article_id: params[:article_id]
  end

  def create
    respond_with :api, Comment.create(comment_params.merge(user_id:    current_user.id,
                                                           article_id: params[:article_id]))
  end

  def update
    respond_with :api, Comment.find(params[:id])
                              .update(comment_params)
  end

  def destroy
    respond_with :api, Comment.destroy(params[:id])
  end

  private
    def comment_params
      params.require(:comment).permit(:content)
    end
end
