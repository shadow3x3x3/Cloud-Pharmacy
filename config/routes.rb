Rails.application.routes.draw do
  root :to => "welcome#index"
  
  get "welcome/say_hello" => "welcome#say"
  get "welcome" => "welcome#index"

  match ':controller(/:action(/:id(.:format)))', :via => :all
end


