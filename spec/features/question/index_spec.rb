require 'rails_helper'

feature 'User can get list of questions' do
  background { create_list(:question, 3) }

  scenario 'User can visit page with all questions' do
    visit questions_path

    expect(page).to have_content('MyString', count: 3)
  end
end
