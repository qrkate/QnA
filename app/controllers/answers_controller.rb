class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_answer, only: [:update, :destroy, :best]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params)
    @answer.files.attach(params[:answer][:files]) if params[:answer][:files].present?
    @question = @answer.question
  end

  def destroy
    if current_user.is_author?(@answer)
      @answer.delete
    end
  end

  def best
    @question = @answer.question
    if current_user.is_author?(@question)
      @answer.best!
    end
  end

  private
  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    if @answer && @answer.files.attached?
      params.require(:answer).permit(:body, links_attributes: [:id, :name, :url, :_destroy])
    else
      params.require(:answer).permit(:body, files: [], links_attributes: [:id, :name, :url, :_destroy])
    end
  end
end
