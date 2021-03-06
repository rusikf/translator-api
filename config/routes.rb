# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :glossaries, only: %i[create show index] do
    resources :terms, only: %i[create]
  end

  resources :translations, only: %i[create show]
end
