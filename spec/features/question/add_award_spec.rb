require 'rails_helper'

feature 'User can add award to question' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  before do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
  end

  scenario 'User adds award when asks question' do
    fill_in 'Award name', with: 'New award'
    attach_file 'Image', "#{Rails.root}/spec/files/award.png"

    click_on 'Ask'

    expect(page).to have_content 'You can get New award award'
  end

  scenario 'User adds invalid award when asks question' do
    fill_in 'Award name', with: 'New award'
    attach_file 'Image', "#{Rails.root}/spec/rails_helper.rb"
    click_on 'Ask'

    expect(page).to have_content 'Award image has an invalid content type'
  end
end
