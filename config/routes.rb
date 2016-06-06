Rails.application.routes.draw do

  devise_for :users, skip: [:sessions], controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  as :user do
    delete "/logout" => "devise/sessions#destroy"
  end

  resources :departments, only: [:index] do
    resources :roles, only: [:index]
    resources :users, only: [:index]
  end

  resources :users, only: [] do
    resources :grants, only: [:index]
    resources :competencies, only: [:index]
  end
  
end
