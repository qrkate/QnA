class Question < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :user

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user

  has_one :award, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :award, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

  after_create { subscribe_user(user) }

  scope :today, -> { where(created_at: Date.today.all_day) }

  def subscribe_user(user)
    subscriptions.create(user: user) unless subscribed?(user)
  end

  def subscribed?(user)
    subscriptions.exists?(user: user)
  end
end
