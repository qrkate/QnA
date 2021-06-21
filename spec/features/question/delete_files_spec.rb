require 'rails_helper'

feature 'User can delete file' do
  given(:question) { create(:question, files: [fixture_file_upload('spec/rails_helper.rb')]) }

  describe 'Authenticated user', js: true do
    scenario 'is author of record' do
      sign_in(question.user)
      visit question_path(question)

      expect(page).to have_link 'rails_helper.rb'

      click_on 'Delete file'

      expect(page).to_not have_link 'rails_helper.rb'
    end

    scenario 'is not author of record' do
      sign_in(create(:user))
      visit question_path(question)

      expect(page).to_not have_link 'Delete file'
    end

    scenario 'Unauthenticated user tries to delete a file' do
      visit question_path(question)

      expect(page).to_not have_link 'Delete file'
    end
  end
end
