# Preview all emails at http://localhost:3000/rails/mailers/question_inform
class QuestionInformPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/question_inform/new_answer
  def new_answer
    QuestionInformMailer.new_answer
  end

end
