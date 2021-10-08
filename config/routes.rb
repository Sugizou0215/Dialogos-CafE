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
  resources :users, only: [:show, :edit, :update] do
    resources :relationships, only: [:create, :destroy]
    get "followings" => 'relationships#followings', as: 'followings'
    get "followers" => 'relationships#followers', as: 'followers'
  end
  resources :chats, only: [:show, :create]
  patch "events/:id/cancel" => "events#cancel", as: 'cancel_event'
  resources :events, except: [:destroy] do
    get "join" => "events#join", as: 'join'
    delete "leave" => "events#leave", as: 'leave'
    resources :event_comments, only: [:create, :destroy]
    resource :bookmarks, only: [:create, :destroy]
  end
  resources :groups, except: [:destroy] do
    get "join" => "groups#join", as: 'join'
    delete "leave" => "groups#leave", as: 'leave'
    resources :applies, only: [:create, :destroy, :index]
    resources :group_news, only: [:new, :create, :edit, :update, :destroy]
    resources :group_comments, only: [:create, :destroy]
  end
end
