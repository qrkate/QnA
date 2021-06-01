require 'rails_helper'

feature 'User can sign up' do

  given(:user) { create(:user) }

  before { visit new_user_registration_path }

  scenario 'User was registered before' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_button 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end

  scenario 'User tryes to sign up with valid attributes' do
    fill_in 'Email', with: 'abc@gmail.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  describe 'User tryes to sign up with invalid' do
    scenario 'email' do
      fill_in 'Email', with: 'abc'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '12345678'
      click_on 'Sign up'

      expect(page).to have_content 'Email is invalid'
    end

    scenario 'password' do
      fill_in 'Email', with: 'abc@gmail.com'
      fill_in 'Password', with: '123'
      fill_in 'Password confirmation', with: '123'
      click_on 'Sign up'

      expect(page).to have_content 'Password is too short (minimum is 6 characters)'
    end

    scenario 'password confirmation' do
      fill_in 'Email', with: 'abc@gmail.com'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '87654321'
      click_on 'Sign up'

      expect(page).to have_content "Password confirmation doesn't match"
    end
  end
end
