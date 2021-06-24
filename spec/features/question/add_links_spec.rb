require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
}, js: true do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:link) { 'github.com' }
  given(:link2) { 'netflix.com' }
  given(:invalid_link) { '//abcd.' }

  scenario 'User adds links when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'Link'
    fill_in 'Url', with: link

    click_on 'Add link'

    within all('.nested-fields').last do
      fill_in 'Link name', with: 'Link 2'
      fill_in 'Url', with: link2
    end

    click_on 'Ask'

    expect(page).to have_link 'Link', href: link
    expect(page).to have_link 'Link 2', href: link2
  end

  describe 'User edits question' do
    background do
      sign_in(question.user)
      visit question_path(question)

      click_on 'Edit question'
    end

    scenario 'with links' do
      within '.question' do
        click_on 'Add link'

        fill_in 'Link name', with: 'Link'
        fill_in 'Url', with: link

        click_on 'Add link'

        within all('.nested-fields').last do
          fill_in 'Link name', with: 'Link 2'
          fill_in 'Url', with: link2
        end

        click_on 'Ask'

        expect(page).to have_link 'Link', href: link
        expect(page).to have_link 'Link 2', href: link2
      end
    end

    scenario 'with invalid link' do
      within '.question' do
        click_on 'Add link'

        fill_in 'Link name', with: 'Link'
        fill_in 'Url', with: invalid_link

        click_on 'Ask'
      end

      expect(page).to have_content 'Links url is an invalid URL'
      expect(page).to_not have_link 'Link', href: invalid_link
    end
  end
end
