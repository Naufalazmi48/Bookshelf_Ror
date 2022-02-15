Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :books, only: [:index, :create, :update, :destroy] do
    get :index, on: :member, to:'books#detail'
  end
end
