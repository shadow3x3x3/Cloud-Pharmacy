Rails.application.routes.draw do
  devise_for :users

  resources :members, :only => [:index] do
    member do
      get :all_fits
      get :fit
      post :add_fit
    end
  end
  resources :hospitals, :pharmacists, :except => [:show]
  resources :agencies, :except => [:show]
  resources :residents, :except => [:show]
  resources :assessment_forms, :prescriptions, :drugs
  root :to => "welcome#index"

  get "welcome/say_hello" => "welcome#say"
  get "welcome" => "welcome#index"


end
