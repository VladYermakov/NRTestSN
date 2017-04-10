class Api::AttachmentsController < ApplicationController
  before_action :authenticate_user!, only: :update

  def show
    article = Article.find(params[:article_id])
    respond_with article.attachment
  end

  def update
    article = Article.find params[:article_id]

    klass = attachment_params[:type].constantize
    sym = attachment_params[:type].underscore.to_sym
    attachment = klass.find_or_create_by attachment_params[sym]

    article.update attachment: attachment
    respond_with article.attachment
  end

  private
    def attachment_params
      params.require(:attachment).permit(:type, :attachment_file, :article, :comment)
    end
end
