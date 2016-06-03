Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  resources :departments, only: [:index] do
    resources :roles, only: [:index]
    resources :users, only: [:index]
  end

  resources :users, only: [] do
    resources :grants, only: [:index]
    resources :competencies, only: [:index]
  end
  
end
