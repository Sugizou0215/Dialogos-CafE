Rails.application.routes.draw do
  root :to => 'homes#top'
  get 'homes/about'
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  get "/confirm" => "users#confirm", as: 'users_confirm'
  put "/users/:id/leave" => "users#leave", as: 'users_leave'
  get "/users" => "users#error"
  resources :users, only: [:show, :edit, :update] do
    resources :relationships, only: [:create, :destroy]
    get "followings" => 'relationships#followings', as: 'followings'
    get "followers" => 'relationships#followers', as: 'followers'
    resources :notices, only: [:index]
    delete "/notices/destroy_all" => 'notices#destroy_all'
  end
  resources :chats, only: [:show, :create]
  get '/chats' => 'chats#error' #hidden_field使用に伴うルーティングエラー用
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
  get "searches/event" => "searches#event"
  get "searches/group" => "searches#group"
  resources :tags, only: [:show]
end
