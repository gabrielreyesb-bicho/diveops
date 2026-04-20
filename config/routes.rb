Rails.application.routes.draw do
  root "home#index"

  # Setup inicial (solo accesible si no hay usuarios)
  get "setup", to: "setup#index"
  post "setup", to: "setup#create"

  # Baja de correos DiveOps (enlace firmado; POST compatible con one-click de Gmail / RFC 8058).
  match "/email/unsubscribe", to: "email_preferences#unsubscribe", via: [ :get, :post ], as: :email_unsubscribe

  get "programs", to: "programs#index", as: :programs
  resources :trips, only: [ :show ], controller: "dive_trips"
  resources :courses, only: [ :show ]

  post "/trips/:id/register", to: "registrations#create", as: :register_trip, defaults: { program_type: "DiveTrip" }
  post "/courses/:id/register", to: "registrations#create", as: :register_course, defaults: { program_type: "Course" }

  devise_for :users,
             path: "agency",
             controllers: {
               registrations: "users/registrations",
               sessions: "users/sessions",
               passwords: "users/passwords"
             }
  # Skip Devise's default registration resource at path "" (it would bind POST/PATCH to "/").
  devise_for :divers,
             path: "",
             skip: [ :registrations ],
             controllers: {
               omniauth_callbacks: "divers/omniauth_callbacks",
               sessions: "divers/sessions",
               passwords: "divers/passwords"
             }

  devise_scope :diver do
    get "/sign_up", to: "divers/registrations#new", as: :new_diver_registration
    post "/sign_up", to: "divers/registrations#create", as: :diver_registration
    get "/my/registrations", to: "divers/registrations#index", as: :my_registrations
  end

  authenticate :diver do
    scope path: "my", module: :divers do
      get "profile", to: "profiles#show", as: :diver_profile
      get "profile/edit", to: "profiles#edit", as: :edit_diver_profile
      patch "profile", to: "profiles#update"
      get "profile/password", to: "profile_passwords#edit", as: :edit_diver_profile_password
      patch "profile/password", to: "profile_passwords#update"
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :staff, path: "agency/dashboard" do
    root to: "dashboard#index"

    resources :divers, only: [ :index, :show ]

    resources :registrations, only: [ :index ] do
      member do
        patch :confirm
        patch :waitlist
        patch :cancel
      end
    end

    resources :dive_trips, path: "trips" do
      member do
        post :publish
        post :confirm
        post :cancel
      end
      resources :photos, only: [ :destroy ], module: :dive_trips
      resources :registrations, only: [ :index ], module: :dive_trips
    end

    resources :courses do
      member do
        post :publish
        post :confirm
        post :cancel
      end
      resources :photos, only: [ :destroy ], module: :courses
      resources :registrations, only: [ :index ], module: :courses
    end
  end

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
