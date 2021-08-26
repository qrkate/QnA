require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    context 'create abilities' do
      it { should be_able_to :create, Question }
      it { should be_able_to :create, Answer }
      it { should be_able_to :create, Comment }
    end

    context 'update abilities' do
      it { should be_able_to :update, create(:question, user: user) }
      it { should_not be_able_to :update, create(:question, user: other) }

      it { should be_able_to :update, create(:answer, user: user) }
      it { should_not be_able_to :update, create(:answer, user: other) }
    end

    context 'destroy abilities' do
      it { should be_able_to :destroy, create(:question, user: user) }
      it { should_not be_able_to :destroy, create(:question, user: other) }

      it { should be_able_to :destroy, create(:answer, user: user) }
      it { should_not be_able_to :destroy, create(:answer, user: other) }

      it { should be_able_to :destroy, ActiveStorage::Attachment }
    end

    context 'other abilities' do
      let(:question1) { create :question, user: user }
      let(:question2) { create :question }

      it { should be_able_to :vote_for, create(:question, user: other) }
      it { should_not be_able_to :vote_for, create(:question, user: user) }

      it { should be_able_to :vote_against, create(:question, user: other) }
      it { should_not be_able_to :vote_against, create(:question, user: user) }

      it { should be_able_to :nullify, create(:question, user: other) }
      it { should_not be_able_to :nullify, create(:question, user: user) }

      it { should be_able_to :best, create(:answer, question: question1) }
      it { should_not be_able_to :best, create(:answer, question: question2) }
    end
  end
end
