require 'rails_helper'

feature 'User can subscribe the question', js: true do
  given(:user) { create(:user) }
  given(:other) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    describe 'other user' do
      before do
        sign_in(other)
        visit question_path(question)
      end

      scenario 'User can subscribe for a question' do
        click_on 'Subscribe'

        expect(page).to have_content 'You subscribed'
        expect(page).to_not have_link 'Subscribe'
        expect(page).to have_link 'Unsubscribe'
      end

      scenario 'subscribes the question' do
        expect(page).not_to have_content 'You subscribed'
        click_on 'Subscribe'

        expect(page).not_to have_link('Subscribe')
        expect(page).to have_link('Unsubscribe')
        expect(page).to have_content 'You subscribed'
      end

      context 'when user has got a subscription of the question' do
        background { question.subscriptions.create!(user: other) }
        before { visit question_path(question)}

        scenario 'views the message that he is already subscribed' do
          expect(page).not_to have_link('Subscribe')
          expect(page).to have_link('Unsubscribe')
        end

        scenario 'unsubscribes to the question' do
          click_on 'Unsubscribe'

          expect(page).not_to have_link('Unsubscribe')
          expect(page).to have_content 'You unsubscribed'
        end

        scenario 'can again subscribe to the question after he unsubscribed'do
          click_on 'Unsubscribe'
          click_on 'Subscribe'

          expect(page).not_to have_link('Subscribe')
          expect(page).to have_link('Unsubscribe')
        end
      end
    end

    describe 'as an author of question' do
      before do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'views message that he is already subscribed as author' do
        expect(page).not_to have_link('Subscribe')
        expect(page).to have_link('Unsubscribe')
      end

      scenario 'unsubscribes to the question' do
        click_on 'Unsubscribe'

        expect(page).not_to have_link('Unsubscribe')
        expect(page).to have_content 'You unsubscribed'
      end

      scenario 'can again subscribe to the question after he unsubscribed' do
        click_on 'Unsubscribe'
        click_on 'Subscribe'

        expect(page).not_to have_link('Subscribe')
        expect(page).to have_link('Unsubscribe')
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can not subscribe or unsubscribe the question' do
      visit question_path(question)

      expect(page).not_to have_link('Subscribe')
      expect(page).not_to have_link('Unsubscribe')
    end
  end
end
