Rails.application.routes.draw do

  devise_for :users, skip: [:sessions], controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  as :user do
    delete "/logout" => "users/sessions#destroy"
  end

  resources :departments, only: [:index] do
    resources :competencies, only: [:index] do
      member do
        get :edit_modal
      end
    end
    resources :roles, only: [:index]
    resources :users, only: [:index]
  end

  resources :grants, only: [:update]
  resources :users, only: [:update] do
    collection do
      get :who_am_i
    end
    resources :grants, only: [:index, :create] do
      collection do
        get :edit_modal
      end
    end
    resources :competencies, only: [:index]
  end

end
