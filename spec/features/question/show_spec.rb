require 'rails_helper'

feature 'User can get question and list of answers' do
  given(:question) { create(:question) }

  background { create_list(:answer, 3, question: question) }

  scenario 'User can visit page with question and all answers' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content('AnswerText', count: 3)
  end
end
