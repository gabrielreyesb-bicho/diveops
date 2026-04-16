# frozen_string_literal: true

module Divers
  # Cambio de contraseña para buzo autenticado (no confundir con Devise::PasswordsController / recuperación).
  class ProfilePasswordsController < ApplicationController
    before_action :authenticate_diver!
    before_action :redirect_google_users

    def edit
    end

    def update
      unless current_diver.valid_password?(password_params[:current_password].to_s)
        flash.now[:alert] = "La contraseña actual no es correcta."
        render :edit, status: :unprocessable_content
        return
      end

      if current_diver.update(password_params.except(:current_password))
        bypass_sign_in(current_diver, scope: :diver)
        redirect_to diver_profile_path, notice: "Contraseña actualizada."
      else
        render :edit, status: :unprocessable_content
      end
    end

    private

    def redirect_google_users
      return unless current_diver.google?

      redirect_to diver_profile_path, alert: "Tu cuenta usa Google; no hay contraseña local que cambiar."
    end

    def password_params
      params.require(:diver).permit(:current_password, :password, :password_confirmation)
    end
  end
end
