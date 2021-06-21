require 'rails_helper'

feature 'User can edit his question' do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Unauthenticated can not edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authenticated user', js: true do

    background do
      sign_in user
      visit question_path(question)

      click_on 'Edit question'
    end

    scenario 'edits his question' do
      within '.question' do
        fill_in 'Title', with: 'edited title'
        fill_in 'Body', with: 'edited body'
        click_on 'Ask'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited title'
        expect(page).to have_content 'edited body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his question with errors' do
      within '.question' do
        fill_in 'Title', with: ''
        click_on 'Ask'

        expect(page).to have_content ''
        expect(page).to have_selector 'textarea'
      end
      expect(page).to have_content "Title can't be blank"
    end

    scenario 'edits a question with attached file' do
      within '.question' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Ask'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end

  scenario "Authenticated user tries to edit other user's question" do
    sign_in(create(:user))
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end
end
