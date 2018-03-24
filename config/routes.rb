Rails.application.routes.draw do
  root 'index#index'

  resources :patterns, except: [:index, :show]
  resources :words, except: [:index, :show]

  namespace :admin do
    resources :patterns, only: [:index, :show] do
      member do
        put 'lock', defaults: { format: :json }
        delete 'lock', action: :unlock, defaults: { format: :json }
      end
    end
    resources :words, only: [:index, :show]
  end
end
