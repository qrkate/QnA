class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_answer, only: [:show, :update, :destroy]
  authorize_resource

  def index
    @question = Question.find(params[:question_id])
    render json: @question.answers
  end

  def show
    render json: @answer, serializer: AnswerShowSerializer
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    if @answer.save
      render json: @answer, serializer: AnswerShowSerializer
    else
      render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @answer.update(answer_params)
      render json: @answer, serializer: AnswerShowSerializer
    else
      render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @answer.destroy
  end

  private
  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
