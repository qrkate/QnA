class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :user, uniqueness: { scope: [:votable_id, :votable_type] }
  validates :value, presence: true, inclusion: { in: [-1, 1] }
end
