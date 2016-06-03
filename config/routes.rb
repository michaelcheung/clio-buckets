Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  resources :departments, only: [:index] do
    resources :users, only: [:index]
  end

end
