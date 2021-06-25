require 'rails_helper'

feature 'User can view his awards' do
  let(:question) { create(:question) }
  given(:awards) { create_list(:award, 3, question: question) }
  given(:user) { create(:user, awards: awards)}

  scenario 'User can visit page with all awards' do
    sign_in(user)
    visit awards_path

    user.awards.each do |award|
      expect(page).to have_content award.question.title
      expect(page).to have_content award.name
    end
  end
end
