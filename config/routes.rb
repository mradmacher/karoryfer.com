# frozen_string_literal: true

Karoryfer::Application.routes.draw do
  root to: 'site#home'

  resources :releases, path: 'wydania', only: %i[show] do
    resource :paypal, path: 'paypal', only: %i[show create]
  end

  get 'wydawnictwa', to: 'site#albums', as: 'albums'
  get 'artysci', to: redirect('wydawnictwa')
  get ':artist_id/wydawnictwa/:album_id', to: redirect('%{artist_id}/%{album_id}')

  scope 'admin', as: 'admin' do
    resources :user_sessions, only: [:create]
    get 'login' => 'user_sessions#new', :as => :login
    get 'logout' => 'user_sessions#destroy', :as => :logout
  end

  namespace :admin, path_names: { new: 'dodaj', edit: 'zmien' } do
    resources :users, path: 'uzytkownicy'
    get 'users/:id/haslo/zmien' => 'users#edit_password', :as => :edit_password
    resources :drafts, path: 'szkice', only: %i[index]
    resources :artists, path: 'artysci', except: %i[index show] do
      resources :pages, path: 'strony', except: %i[show]
      resources :albums, path: 'wydawnictwa', except: %i[index show] do
        resources :attachments, path: 'zalaczniki', only: %i[index show create destroy]
        resources :tracks, path: 'sciezki', except: [:new]
        resources :releases, path: 'wydania', except: %i[new]
      end
    end
  end

  resources :artists, path: '', only: %i[show]
  scope ':artist_id', as: 'artist' do
    resources :albums, path: '', only: %i[show] do
      member do
        get 'zip', to: 'albums#download', as: 'download'
      end
    end
    resources :pages, path: '-', only: %i[show]

    # for backward compatibility
    resources :albums, path: 'wydawnictwa', only: [] do
      member { get 'zip', to: 'albums#download', as: 'old_download' }
    end
  end

end
