Karoryfer::Application.routes.draw do
	scope 'admin', :as => 'admin' do
		resources :user_sessions, :only => [:create]
		match 'login' => "user_sessions#new", :as => :login
		match 'logout' => "user_sessions#destroy", :as => :logout
		scope :path_names => { :edit => 'zmien', :new => 'dodaj' } do
			resources :users, :path => 'uzytkownicy'
      resources :memberships, :only => [:create, :destroy]
		end
		match 'users/:id/haslo/zmien' => 'users#edit_password', :as => :edit_password
	end

  root :to => 'site#home'

  match 'wydarzenia/kalendarz' => 'events#calendar', :as => :calendar_events
  match 'wydarzenia/z/:year(/:month(/:day))' => 'events#index', :as => :events_from
  match 'wiadomosci/z/:year' => 'posts#index', :as => :posts_from

	scope :path_names => { :new => 'dodaj', :edit => 'zmien' } do
		resources :videos, :path => 'filmy', :only => [:index]
		resources :posts, :path => 'wiadomosci', :only => [:index]
		resources :events, :path => 'wydarzenia', :only => [:index]

		resources :artists, :path => 'artysci'
		resources :albums, :path => 'wydawnictwa'
	end

	match ':id' => 'artists#show', :as => :artist, :via => :get
	match ':id' => 'artists#update', :as => :artist, :via => :put
	resources :artists, :path => 'artysci'
	scope ':artist_id', :as => 'artist', :path_names => { :new => 'dodaj', :edit => 'zmien' } do
    resources :albums, :path => 'wydawnictwa'
		resources :videos, :path => 'filmy'
		resources :posts, :path => 'wiadomosci' do
      collection do
        get :drafts, :path => 'szkice'
      end
    end
		resources :events, :path => 'wydarzenia' do
      collection do
        get :drafts, :path => 'szkice'
      end
    end
		resources :artists, :only => [:show]
    resources :pages, :path => 'strony', :except => [:show, :update, :index]
    match ':id' => 'pages#show', :as => 'page', :via => :get
    match ':id' => 'pages#update', :as => 'page', :via => :put
    match ':id' => 'pages#destroy', :as => 'page', :via => :delete
	end
end

