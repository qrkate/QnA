require 'rails_helper'

feature 'User can delete answer' do
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user' do
    scenario 'is author of answer' do
      sign_in(answer.user)
      visit question_path(question)

      expect(page).to have_content answer.body

      click_on 'Delete answer'

      expect(page).to have_content 'Your answer successfully deleted.'
      expect(page).to_not have_content answer.body
    end

    scenario 'is not author of question' do
      sign_in(create(:user))
      visit question_path(question)

      expect(page).to_not have_link 'Delete answer'
    end
  end

  scenario 'Unauthenticated user tries to delete a answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end
end
