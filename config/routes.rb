Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: "registrations"}
  
  devise_scope :user do
    authenticated :user do
      root 'registrations#dashboard', as: :authenticated_root
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end
end
