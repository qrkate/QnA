require 'rails_helper'

feature 'User can edit his answer', %q{
In order to correct mistakes
As an author of answer
I'd like ot be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:link) { create(:link) }
  given!(:answer) { create(:answer, question: question, user: user, links: [link]) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do

    background do
      sign_in user
      visit question_path(question)

      click_on 'Edit'
    end

    scenario 'edits his answer' do
      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Answer'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors' do
      within '.answers' do
        fill_in 'Your answer', with: ''
        click_on 'Answer'

        expect(page).to have_content ''
        expect(page).to have_selector 'textarea'
      end
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'edits his answer with attached file' do
      within '.answers' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Answer'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'can delete link' do
      expect(page).to have_link link.name, href: link.url

      within '.answers' do
        click_on 'Delete link'
        click_on 'Answer'

        expect(page).to_not have_link link.name, href: link.url
      end
    end
  end

  scenario "Authenticated user tries to edit other user's question" do
    sign_in(create(:user))
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end
