class AttachmentFile < ApplicationRecord
  has_attached_file :source
  validates_attachment_content_type :source,
                       content_type: /(?!application\/octet-stream)/,
                       message: 'You don\'t able to attach executable file'

  has_many :articles, as: :attachment, dependent: :nullify
end
