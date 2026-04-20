# frozen_string_literal: true

class SetupController < ApplicationController
  # Solo permitir acceso si no hay usuarios en el sistema
  before_action :redirect_if_setup_complete

  def index
    # Mostrar formulario de setup
  end

  def create
    agency = Agency.find_or_create_by!(slug: "deepsoul") do |a|
      a.name = "DeepSoul"
      a.contact_email = "contacto@deepsoul.com"
    end

    user = User.create!(
      email: "admin@deepsoul.com",
      name: "Admin DeepSoul",
      agency: agency,
      role: :owner,
      password: "ChangeMe2026!",
      password_confirmation: "ChangeMe2026!"
    )

    flash[:notice] = "Setup completado. Email: #{user.email} / Password: ChangeMe2026!"
    redirect_to new_user_session_path
  rescue => e
    flash[:alert] = "Error en setup: #{e.message}"
    redirect_to setup_path
  end

  private

  def redirect_if_setup_complete
    redirect_to root_path if User.any?
  end
end
