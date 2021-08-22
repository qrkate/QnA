class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :body, presence: true

  default_scope { order(:created_at) }

  def find_question
    return commentable if commentable_type == 'Question'
    return commentable.question if commentable_type == 'Answer'
  end
end
