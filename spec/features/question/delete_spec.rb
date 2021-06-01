require 'rails_helper'

feature 'User can delete question' do
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    scenario 'is author of question' do
      sign_in(question.user)
      visit question_path(question)

      expect(page).to have_content 'MyString'

      click_on 'Delete question'

      expect(page).to have_content 'Your question successfully deleted.'
      expect(page).to_not have_content 'MyString'
    end

    scenario 'is not author of question' do
      sign_in(create(:user))
      visit question_path(question)

      expect(page).to_not have_link 'Delete question'
    end
  end

  scenario 'Unauthenticated user tries to delete a question' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete question'
  end
end
