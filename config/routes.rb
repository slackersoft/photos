Photos::Application.routes.draw do

  resources :photos, :only => [:index]
  root :to => "roots#index"
end
