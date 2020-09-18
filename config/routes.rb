Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  devise_scope :user do
    get  'profiles', to: 'users/registrations#new_profile'
    post 'profiles', to: 'users/registrations#create_profile'
  end
  $date = Time.now.in_time_zone('Tokyo').to_s
  root "articles#index"
  resources :articles do
    collection do
      post "markdown"
      post "set_blob"
      post "search"
      get "set_draft"
    end
  end
  resources :drafts, only: [:index, :edit, :update, :show, :destroy]
  resources :tags, only: [:show]
end
