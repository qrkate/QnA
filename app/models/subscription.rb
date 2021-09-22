class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :user, :question, presence: true
end
