Rails.application.routes.draw do
  use_doorkeeper
  root to: 'questions#index'

  devise_for :users

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, shallow: true, except: [:new] do
        resources :answers, except: [:new]
      end
    end
  end

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
  resources :comments, only: :create

  mount ActionCable.server => '/cable'
end
