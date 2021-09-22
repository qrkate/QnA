class QuestionInformService
  def send_answer(answer)
    answer.question.subscribers.find_each do |user|
      QuestionInformMailer.new_answer(user, answer).deliver_later
    end
  end
end
