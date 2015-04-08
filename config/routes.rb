Photos::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  devise_scope :user do
    get 'sign_in', :to => 'users/sessions#new', :as => :new_session
    get 'sign_out', :to => 'users/sessions#destroy', :as => :destroy_session
  end

  resources :photos, :only => [:new, :create, :show, :destroy] do
    member do
      post :add_tag
      post :remove_tag
    end
  end

  resource :account, :only => [:show, :update] do
    resources :sender_emails, :only => [:create, :destroy]
    namespace :let_me_know do
      resource :preferences, :only => :create
      resource :preference, :only => :update
    end
  end

  get "/:tag_name" => "tags#show"
  root :to => "roots#index"
end
