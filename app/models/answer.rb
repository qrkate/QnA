class Answer < ApplicationRecord
  include Votable
  include Commentable

  default_scope { order(best: :desc) }

  belongs_to :question
  belongs_to :user

  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  def best!
    self.transaction do
      question.answers.update_all(best: false)
      update!(best: true)
      question.award.update!(user: user) unless question.award.nil?
    end
  end
end
