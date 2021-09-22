class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource
  
  def create
    @question = Question.find(params[:question_id])
    @question.subscribe_user(current_user)

    redirect_to question_path(@question), notice: 'You subscribed'
  end

  def destroy
    @question = Question.find(params[:question_id])
    @subscription = current_user.subscriptions.find_by(question: @question)
    @subscription.destroy

    redirect_to question_path(@question), notice: 'You unsubscribed'
  end
end
