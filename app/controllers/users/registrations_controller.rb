# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    layout "auth", only: [ :new ]

    before_action :configure_sign_up_params, only: [ :create ]
    before_action :configure_account_update_params, only: [ :update ]

    # Sobrescribir para evitar mensaje flash
    def update
      super do |resource|
        # No mostrar mensaje flash después de actualizar
        flash.discard(:notice) if flash[:notice]
      end
    end

    protected

    # Permite actualizar sin contraseña si no se está cambiando
    def update_resource(resource, params)
      if params[:password].blank? && params[:password_confirmation].blank?
        # Si no hay nueva contraseña, actualizamos sin requerir contraseña
        params.delete(:current_password)
        resource.update_without_password(params.except(:current_password))
      else
        # Si hay nueva contraseña, validamos con contraseña actual
        resource.update_with_password(params)
      end
    end

    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [ :name, :agency_id ])
    end

    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: [ :name, :avatar ])
    end
  end
end
