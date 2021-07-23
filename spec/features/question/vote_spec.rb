require 'rails_helper'

feature 'User can vote', js: true do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'votes for the question' do
      within '.question' do
        click_on '+'

        within '.rating' do
          expect(page).to have_content '1'
        end
      end
    end

    scenario 'votes against the question' do
      within '.question' do
        click_on '-'

        within '.rating' do
          expect(page).to have_content '-1'
        end
      end
    end

    scenario 'nullify the vote and revote' do
      within '.question' do
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

    scenario 'votes for the question twice' do
      within '.question' do
        click_on '+'
        click_on '+'

        within '.rating' do
          expect(page).to have_content '1'
        end
      end
    end

    scenario 'votes against the question twice' do
      within '.question' do
        click_on '-'
        click_on '-'

        within '.rating' do
          expect(page).to have_content '-1'
        end
      end
    end
  end

  scenario 'Unauthenticated user can not vote' do
    visit question_path(question)

    expect(page).to_not have_link '+'
    expect(page).to_not have_link '-'
    expect(page).to_not have_link 'Nullify'
    expect(page).to_not have_selector '.vote'
  end
end
