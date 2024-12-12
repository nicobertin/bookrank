Rails.application.routes.draw do
  root to: "pages#home"

  get "/home", to: "pages#home", as: :home


  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  scope :users, as: :users do
    get  "/register", to: "users#register", as: :register
    get  "/login", to: "users#login", as: :login
  end

  scope :auth, as: :auth do
    post "/register", to: "authentication#register", as: :register
    post "/login", to: "authentication#login", as: :login
    delete "/logout", to: "authentication#logout", as: :logout
  end
end
