class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :find_answer, only: [:update, :destroy, :best]
  after_action :publish_answer, only: :create

  authorize_resource

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
    @answer.delete
  end

  def best
    @question = @answer.question
    @answer.best!
  end

  private
  def publish_answer
    return unless @answer.valid?

    data = { answer: ApplicationController.render(
                        partial: 'answers/answer_new',
                        locals: { answer: @answer }
                      ),
            user_id: current_user.id }

    QuestionChannel.broadcast_to(@answer.question, data)
  end

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
