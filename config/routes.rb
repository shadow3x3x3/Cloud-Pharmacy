Rails.application.routes.draw do
  devise_for :users

  resources :members, only: [:index] do
    member do
      resources :fits, except: [:show]
    end
  end
  resources :hospitals, :pharmacists, except: [:show]
  resources :agencies, except: [:show]
  resources :residents, except: [:show]
  resources :assessment_forms, :prescriptions

  resources :drugs do
    collection do
      get :search
    end
  end

  resources :prescriptions do
    patch :deal, on: :member
  end

  root to: 'welcome#index'
  get 'welcome/say_hello', to: 'welcome#say'
  get 'welcome', to: 'welcome#index'
end
