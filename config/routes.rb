# frozen_string_literal: true

Rails.application.routes.draw do
  concern :check do
    post :check, on: :collection, defaults: { format: :json }
  end

  concern :toggle do
    post :toggle, on: :member, defaults: { format: :json }
  end

  concern :priority do
    post :priority, on: :member, defaults: { format: :json }
  end

  concern :removable_image do
    delete :image, action: :destroy_image, on: :member, defaults: { format: :json }
  end

  concern :lock do
    member do
      put :lock, defaults: { format: :json }
      delete :lock, action: :unlock, defaults: { format: :json }
    end
  end

  resources :patterns, only: %i[update destroy]

  scope '(:locale)', constraints: { locale: /ru|en/ } do
    root 'index#index'

    resources :patterns, only: %i[new create edit], concerns: :check

    namespace :admin do
      resources :patterns, only: %i[index show]
    end
  end
end
