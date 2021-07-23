Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  concern :voted do
    member do
      patch :vote_for
      patch :vote_against
      patch :nullify
    end
  end

  resources :questions, concerns: [:voted] do
    resources :answers, concerns: [:voted], shallow: true do
      patch :best, on: :member
    end
  end

  resources :files, only: :destroy
  resources :awards, only: :index
end
