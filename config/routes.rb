Rails.application.routes.draw do
  resources :hospitals, :pharmacists
  root :to => "welcome#index"

  get "welcome/say_hello" => "welcome#say"
  get "welcome" => "welcome#index"


end


