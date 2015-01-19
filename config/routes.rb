Karoryfer::Application.routes.draw do
  scope 'admin', :as => 'admin' do
    resources :user_sessions, only: [:create]
    get 'login' => "user_sessions#new", :as => :login
    get 'logout' => "user_sessions#destroy", :as => :logout
    scope path_names: { edit: 'zmien', new: 'dodaj' } do
      resources :users, path: 'uzytkownicy'
      resources :memberships, only: [:create, :destroy]
    end
    get 'users/:id/haslo/zmien' => 'users#edit_password', :as => :edit_password
  end

  root :to => 'site#home'

  get 'wydarzenia/kalendarz', to: 'events#calendar', as: 'calendar_events'
  get 'wydarzenia/z/:year(/:month(/:day))', to: 'site#events', as: 'events_from'
  get 'wiadomosci/z/:year', to: 'site#posts', as: :posts_from
  get 'wydarzenia', to: 'site#events', as: 'events'
  get 'wiadomosci', to: 'site#posts', as: 'posts'
  get 'filmy', to: 'site#videos', as: 'videos'
  get 'wydawnictwa', to: 'site#albums', as: 'albums'
  get 'artysci', to: 'site#artists', as: 'artists'
  get 'szkice', to: 'site#drafts', as: 'drafts'

  scope path_names: { new: 'dodaj', edit: 'zmien' } do
    resources :artists, path: '', only: [:show, :edit, :new, :update]
    resources :artists, path: 'artysci', only: [:create]
  end

  scope ':artist_id', as: 'artist', path_names: { new: 'dodaj', edit: 'zmien' } do
    resources :albums, path: 'wydawnictwa' do
      member do
        get ':format', to: 'albums#download', as: 'download', constraints: { format: /.{1,4}/ }
      end
      resources :attachments, path: 'zalaczniki', only: [:show, :new, :create, :destroy]
      resources :tracks, path: 'sciezki', only: [:show, :new, :edit, :create, :update, :destroy]
    end
    resources :videos, path: 'filmy'
    resources :posts, path: 'wiadomosci'
    resources :events, path: 'wydarzenia'
    resources :pages, path: 'informacje'
  end
end

