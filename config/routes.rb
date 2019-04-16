Rails.application.routes.draw do

  resources :searches, only: [:new, :create]

  get 'logo/create'
  get 'logo/destroy'

  resources :charts, only: [] do
    collection do
      get 'test_by_score'
      get 'test_by_subject'
    end
  end
  
  resources :teachers do
    resources :questions
    resources :tests, only: [:new, :create, :show]
  end

  resources :students, only: [:new, :create, :show, :edit, :update, :destroy] do
    resources :tests, only: [:show] do
      resources :doing_tests, only: [:new, :create]
    end
    
    resources :exams do
      resources :doing_exams, only: [:new, :create]
    end
    
    resources :results, only: [:index, :show]
  end

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin' do
    resources :question_to_tests
    resources :add_option_to_questions, only: [:new, :create, :edit, :update, :destroy]
  end

  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
end
