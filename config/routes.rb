# frozen_string_literal: true

Karoryfer::Application.routes.draw do
  scope 'admin', as: 'admin' do
    resources :user_sessions, only: [:create]
    get 'login' => 'user_sessions#new', :as => :login
    get 'logout' => 'user_sessions#destroy', :as => :logout
    scope path_names: { edit: 'zmien', new: 'dodaj' } do
      resources :users, path: 'uzytkownicy'
    end
    get 'users/:id/haslo/zmien' => 'users#edit_password', :as => :edit_password
  end

  root to: 'site#home'

  resources :releases, path: 'wydania', only: %i[show] do
    resource :paypal, path: 'paypal', only: %i[show create]
  end

  get 'wydawnictwa', to: 'site#albums', as: 'albums'
  get 'artysci', to: 'site#artists', as: 'artists'
  get 'szkice', to: 'site#drafts', as: 'drafts'

  scope path_names: { new: 'dodaj', edit: 'zmien' } do
    resources :artists, path: '', only: %i[show edit new update]
    resources :artists, path: 'artysci', only: [:create]
  end

  scope ':artist_id', as: 'artist', path_names: { new: 'dodaj', edit: 'zmien' } do
    resources :albums, path: 'wydawnictwa' do
      member do
        get ':format', to: 'albums#download', as: 'download', constraints: { format: /mp3|ogg|flac|zip|bandcamp/ }
      end
      resources :attachments, path: 'zalaczniki', only: %i[index show create destroy]
      resources :tracks, path: 'sciezki', except: [:new]
      resources :releases, path: 'wydania', except: %i[new]
    end
    resources :pages, path: '-'
  end
end
