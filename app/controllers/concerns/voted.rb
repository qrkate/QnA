module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_votable, only: [:vote_for, :vote_against, :nullify, :user_not_author, :revote!]
    before_action :user_not_author, only: [:vote_for, :vote_against, :nullify]
    before_action :revote!, only: [:vote_for, :vote_against, :nullify]
  end

  def vote_for
    @votable.votes.create!(user: current_user, value: 1)
    render_json
  end

  def vote_against
    @votable.votes.create!(user: current_user, value: -1)
    render_json
  end

  def nullify
    render_json
  end

  private

  def render_json
    render json: {
      id: @votable.id,
      type: @votable.class.to_s.downcase,
      rating: @votable.rating
    }
  end

  def find_votable
    @votable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end

  def user_not_author
    authorize! :all_vote_actions, @votable
  end

  def revote!
    @votable.revote(current_user)
  end
end
