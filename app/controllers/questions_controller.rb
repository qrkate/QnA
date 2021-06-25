class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.new
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
    if current_user.is_author?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Your question successfully deleted.'
    else
      redirect_to questions_path
    end
  end

  private
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
