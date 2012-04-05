Photos::Application.routes.draw do

  resources :photos, :only => [:show]
  root :to => "roots#index"
end
