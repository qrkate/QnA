require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
}, js: true do

  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }
  given(:link) { 'github.com' }
  given(:link2) { 'netflix.com' }
  given(:invalid_link) { '//abcd.' }

  background do
    sign_in(answer.user)
    visit question_path(question)
  end

  scenario 'User adds links when give an answer' do
    fill_in 'Your answer', with: 'My answer'

    fill_in 'Link name', with: 'Link'
    fill_in 'Url', with: link

    click_on 'Add link'

    within all('.nested-fields').last do
      fill_in 'Link name', with: 'Link 2'
      fill_in 'Url', with: link2
    end

    click_on 'Answer'

    expect(page).to have_link 'Link', href: link
    expect(page).to have_link 'Link 2', href: link2
  end

  scenario 'User adds links when edit an answer' do
    click_on 'Edit'

    within '.answers' do
      click_on 'Add link'

      fill_in 'Link name', with: 'Link'
      fill_in 'Url', with: link

      click_on 'Add link'

      within all('.nested-fields').last do
        fill_in 'Link name', with: 'Link 2'
        fill_in 'Url', with: link2
      end

      click_on 'Answer'

      expect(page).to have_link 'Link', href: link
      expect(page).to have_link 'Link 2', href: link2
    end
  end

  scenario 'User adds invalid link when edit an answer' do
    click_on 'Edit'

    within '.answers' do
      click_on 'Add link'

      fill_in 'Link name', with: 'Link'
      fill_in 'Url', with: invalid_link

      click_on 'Answer'
    end

    expect(page).to have_content 'Links url is an invalid URL'
    expect(page).to_not have_link 'Link', href: invalid_link
  end
end
