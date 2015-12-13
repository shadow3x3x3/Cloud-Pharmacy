Rails.application.routes.draw do
  devise_for :users
  resources :hospitals, :pharmacists, :except => [:show]
  resources :members, :agencies, :except => [:show]
  resources :fits, :drugs, :except => [:show]
  resources :residents, :except => [:show]
  resources :assessment_forms, :prescriptions
  root :to => "welcome#index"

  get "welcome/say_hello" => "welcome#say"
  get "welcome" => "welcome#index"


end
