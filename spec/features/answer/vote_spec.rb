require 'rails_helper'

feature 'User can vote', js: true do
  given(:user) { create(:user) }
  given!(:answer) { create(:answer) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(answer.question)
    end

    scenario 'votes for the answer' do
      within '.answers' do
        click_on '+'

        within '.rating' do
          expect(page).to have_content '1'
        end
      end
    end

    scenario 'votes against the answer' do
      within '.answers' do
        click_on '-'

        within '.rating' do
          expect(page).to have_content '-1'
        end
      end
    end

    scenario 'nullify the vote and revote' do
      within '.answers' do
        click_on '+'

        within '.rating' do
          expect(page).to have_content '1'
        end

        click_on 'Nullify'

        within '.rating' do
          expect(page).to have_content '0'
        end

        click_on '-'

        within '.rating' do
          expect(page).to have_content '-1'
        end
      end
    end

    scenario 'votes for the answer twice' do
      within '.answers' do
        click_on '+'
        click_on '+'

        within '.rating' do
          expect(page).to have_content '1'
        end
      end
    end

    scenario 'votes against the answer twice' do
      within '.answers' do
        click_on '-'
        click_on '-'

        within '.rating' do
          expect(page).to have_content '-1'
        end
      end
    end
  end

  scenario 'Unauthenticated user can not vote' do
    visit question_path(answer.question)

    expect(page).to_not have_link '+'
    expect(page).to_not have_link '-'
    expect(page).to_not have_link 'Nullify'
    expect(page).to_not have_selector '.vote'
  end
end
