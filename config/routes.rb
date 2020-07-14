Rails.application.routes.draw do
  root 'products#index'

  resources :products, only: [:index, :show]

  resources :stocks, only: [] do
    member do
      get :come_in
      post :come_in

      post :come_out

      get :adjust
      post :adjust

      get :transfer
      post :transfer
    end
  end

  mount RailsEventStore::Browser => '/res' if Rails.env.development?
end
