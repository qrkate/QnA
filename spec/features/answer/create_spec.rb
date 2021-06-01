require 'rails_helper'

feature 'User can create answer' do
  given(:question) { create(:question) }

  background { visit question_path(question) }

  scenario 'give an answer' do
    fill_in 'Body', with: 'text text text'
    click_on 'Answer'

    expect(page).to have_content 'Your answer successfully created.'
    expect(page).to have_content 'text text text'
  end

  scenario 'give an answer with errors' do
    click_on 'Answer'

    expect(page).to have_content "Body can't be blank"
  end
end
