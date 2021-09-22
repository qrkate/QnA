class QuestionInformJob < ApplicationJob
  queue_as :default

  def perform(answer)
    QuestionInformService.new.send_answer(answer)
  end
end
