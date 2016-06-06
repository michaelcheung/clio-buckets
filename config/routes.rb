Rails.application.routes.draw do

  devise_for :users, skip: [:sessions], controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  as :user do
    delete "/logout" => "users/sessions#destroy"
  end

  resources :departments, only: [:index] do
    resources :competencies, only: [:index]
    resources :roles, only: [:index]
    resources :users, only: [:index]
  end
  
  resources :users, only: [:update] do
    resources :grants, only: [:index, :create]
    resources :competencies, only: [:index]
  end
  
end
