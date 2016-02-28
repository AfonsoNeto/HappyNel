Rails.application.routes.draw do
  resources :polls, only: [:create] do
    get   'vote'     , on: :member
    patch 'set_score', on: :collection
  end

  devise_for :users, skip: [:registrations], controllers: {registrations: "registrations"}
  
  devise_scope :user do
    authenticated :user do
      root    'registrations#dashboard',   as: :authenticated_root
      post    'create_member',             to: 'registrations#create_member'
      delete  '/users/:id/destroy_member', to: 'registrations#destroy_member', as: :destroy_member
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  # Static pages routes
  get '/thanks_to_vote', to: redirect('/voted.html')
end
