Karoryfer::Application.routes.draw do
	scope 'admin', :as => 'admin' do
		resources :user_sessions, only: [:create]
		match 'login' => "user_sessions#new", :as => :login
		match 'logout' => "user_sessions#destroy", :as => :logout
		scope path_names: { edit: 'zmien', new: 'dodaj' } do
			resources :users, path: 'uzytkownicy'
      resources :memberships, only: [:create, :destroy]
		end
		match 'users/:id/haslo/zmien' => 'users#edit_password', :as => :edit_password
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
		resources :artists, path: 'artysci'
	end

	match ':id' => 'artists#show', :as => :artist, :via => :get
	match ':id' => 'artists#update', :as => :artist, :via => :put
	resources :artists, path: 'artysci'
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
		resources :artists, only: [:show]
    resources :pages, path: 'informacje', except: [:show, :update, :index]
    match ':id' => 'pages#show', as: 'page', via: :get
    match ':id' => 'pages#update', as: 'page', via: :put
    match ':id' => 'pages#destroy', as: 'page', via: :delete
	end
end

