class QuestionChannel < ApplicationCable::Channel
  def follow(data)
    question = Question.find(data["id"])
    stream_for question
  end
end
