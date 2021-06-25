class Award < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :question

  has_one_attached :image

  validates :name, presence: true
  validates :image, attached: true,
                    content_type: [:png, :jpg, :jpeg]
end
