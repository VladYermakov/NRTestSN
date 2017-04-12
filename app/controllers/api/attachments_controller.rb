class Api::AttachmentsController < ApplicationController
  before_action :authenticate_user!, only: :update

  def show
    article = Article.find(params[:article_id])
    respond_with :api, article.attachment
  end

  def create
    respond_with :api, AttachmentFile.create(source: params[:source]), location: nil
  end

  def update
    article = Article.find params[:article_id]

    klass = attachment_params[:type].camelize.constantize
    sym = attachment_params[:type].underscore.to_sym
    attachment = klass.find attachment_params[sym][:id]

    article.update attachment: attachment
    respond_with :api, article.attachment, location: nil
  end

  private
    def attachment_params
      params.require(:attachment).permit(:type, attachment_file: :id,
                                                article: :id, comment: :id)
    end
end
