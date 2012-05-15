Photos::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  devise_scope :user do
    get 'sign_in', :to => 'users/sessions#new', :as => :new_session
    get 'sign_out', :to => 'users/sessions#destroy', :as => :destroy_session
  end

  resources :photos, :only => [:show] do
    member do
      post :add_tag
    end
  end
  root :to => "roots#index"
end
