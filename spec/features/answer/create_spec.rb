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
      fill_in 'Your answer', with: 'text text text'
      click_on 'Answer'

      expect(page).to have_content 'text text text'
    end

    scenario 'give an answer with errors' do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'give an answer with attached file' do
      fill_in 'Your answer', with: 'text text text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user tries to give an answer' do
    visit question_path(question)
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
