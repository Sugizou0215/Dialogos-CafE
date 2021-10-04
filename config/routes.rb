Rails.application.routes.draw do
  root :to => 'homes#top'
  get 'homes/about'
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    registrations: 'users/registrations'
  }
  get "/confirm" => "users#confirm", as: 'users_confirm'
  put "/users/:id/leave" => "users#leave", as: 'users_leave'
  resources :users, only: [:show, :edit, :update]
end
