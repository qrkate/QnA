require 'rails_helper'

feature 'User can mark answer as best' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer1) { create(:answer, question: question) }
  given!(:answer2) { create(:answer, question: question) }

  context 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'marks answer as best' do
      within ("#answer-#{answer2.id}") do
        click_on('Best answer')

        expect(page).to have_content 'The best answer'
        expect(page).to_not have_link 'Best answer'
      end

      within ("#answer-#{answer1.id}") do
        expect(page).to_not have_content 'The best answer'
        expect(page).to have_link 'Best answer'
      end
    end

    scenario 'marks answer as best with question award' do
      create(:award, question: question)

      within ("#answer-#{answer1.id}") do
        click_on('Best answer')

        expect(page).to have_content 'The best answer'
        expect(page).to have_content "You win an award:"
        expect(page).to_not have_link 'Best answer'
      end
    end
  end

  scenario 'Unauthenticated user does not mark as best' do
    visit question_path(question)

    expect(page).to_not have_link 'Best answer'
  end
end
