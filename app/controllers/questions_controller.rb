class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :update, :destroy]
  after_action :publish_question, only: :create

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.new
    gon.user_id = current_user&.id
  end

  def new
    @question = Question.new
    @question.links.new # .build
    @question.award = Award.new
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params)
    @question.files.attach(params[:question][:files]) if params[:question][:files].present?
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'Your question successfully deleted.'
  end

  private
  def publish_question
    return unless @question.valid?

    ActionCable.server.broadcast('questions',
                                     { question_title: ApplicationController.render(
                                                        partial: 'questions/question_title',
                                                        locals: { question: @question }
                                    ) }
                                  )
  end

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    if @question && @question.files.attached?
      params.require(:question).permit(:title, :body, links_attributes: [:id, :name, :url, :_destroy],
                                                      award_attributes: [:id, :name, :image, :_destroy])
    else
      params.require(:question).permit(:title, :body, files: [], links_attributes: [:id, :name, :url, :_destroy],
                                                                award_attributes: [:id, :name, :image, :_destroy])
    end
  end
end
