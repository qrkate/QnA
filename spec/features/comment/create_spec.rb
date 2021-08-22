require 'rails_helper'

feature 'User can create comments' do

  given! (:user) { create(:user) }
  given! (:question) { create(:question) }
  given! (:answer) { create(:answer, question: question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'comments a question' do
      within ".question" do
        fill_in 'New comment', with: 'Comment text'
        click_on 'Comment'

        expect(page).to have_content "Comment text"
      end
    end

    scenario 'comments an answer' do
      within all('.answers').last do
        fill_in 'New comment', with: 'Comment text'
        click_on 'Comment'

        expect(page).to have_content "Comment text"
      end
    end
  end

  scenario "Comment appears on another user's page", js: true do
    Capybara.using_session('user') do
      sign_in(user)
      visit question_path(question)
    end

    Capybara.using_session('quest') do
      visit question_path(question)

      expect(page).to_not have_content 'Question comment'
      expect(page).to_not have_content 'Answer comment'
    end

    Capybara.using_session('user') do
      within ".question" do
        fill_in 'New comment', with: 'Question comment'
        click_on 'Comment'

        expect(page).to have_content "Question comment"
      end

      within all('.answers').last do
        fill_in 'New comment', with: 'Answer comment'
        click_on 'Comment'

        expect(page).to have_content "Answer comment"
      end
    end

    Capybara.using_session('quest') do
      within ".question" do
        expect(page).to have_content "Question comment"
      end

      within all('.answers').last do
        expect(page).to have_content "Answer comment"
      end
    end
  end

  scenario 'Unauthenticated user tryes to comment a question' do
    visit question_path(question)
    expect(page).to_not have_button 'Comment'
  end
end
