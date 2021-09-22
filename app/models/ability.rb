# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Subscription]
    can [:update, :destroy], [Question, Answer], user_id: user.id

    can :best, Answer, question: { user_id: user.id }
    can :destroy, ActiveStorage::Attachment, record: { user_id: user.id }
    can :destroy, Subscription, user_id: user.id

    alias_action :vote_for, :vote_against, :nullify, to: :all_vote_actions
    can :all_vote_actions, [Question, Answer] do |votable|
      votable.user_id != user.id
    end

    can :me, User, id: user.id
  end
end
