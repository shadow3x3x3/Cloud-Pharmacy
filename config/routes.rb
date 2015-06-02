Rails.application.routes.draw do
  resources :hospitals, :pharmacists, :except => [:show]
  root :to => "welcome#index"

  get "welcome/say_hello" => "welcome#say"
  get "welcome" => "welcome#index"


end


