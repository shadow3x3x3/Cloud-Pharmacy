Rails.application.routes.draw do
  resources :hospitals, :pharmacists, :except => [:show]
  resources :members, :agencies, :except => [:show]
  resources :fits, :drugs, :except => [:show]
  resources :residents, :prescriptions, :except => [:show]

  root :to => "welcome#index"

  get "welcome/say_hello" => "welcome#say"
  get "welcome" => "welcome#index"


end


