Rails.application.routes.draw do
  resources :patterns, :words, only: [:update, :destroy]

  scope '(:locale)', constraints: { locale: /[a-z]{2}/ } do
    root 'index#index'

    resources :patterns, :words, only: [:new, :create, :edit]

    controller :dreambook do
      get 'w/(:slug)' => :show, as: :dreambook_pattern, constraints: { slug: /[^\/]+/ }
      get 'search' => :search
    end

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
end
