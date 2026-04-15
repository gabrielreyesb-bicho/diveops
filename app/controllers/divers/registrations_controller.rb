# frozen_string_literal: true

module Divers
  class RegistrationsController < Devise::RegistrationsController
    layout :diver_registration_layout

    before_action :configure_sign_up_params, only: [ :create ]
    before_action :configure_account_update_params, only: [ :update ]
    before_action :authenticate_diver!, only: [ :index ]

    def index
      @registrations = current_diver.registrations.includes(program: :agency).order(created_at: :desc)
    end

    private

    def diver_registration_layout
      action_name == "index" ? "application" : "auth"
    end

    protected

    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
    end

    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: [ :name ])
    end
  end
end
