require 'rails_helper'

feature 'User can create answer' do
  given(:question) { create(:question) }
  given(:user) { create(:user) }

  describe 'Authenticated user', js: true do

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'give an answer' do
      fill_in 'Body', with: 'text text text'
      click_on 'Answer'

      expect(page).to have_content 'text text text'
    end

    scenario 'give an answer with errors' do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to give an answer' do
    visit question_path(question)
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
