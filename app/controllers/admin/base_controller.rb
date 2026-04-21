# frozen_string_literal: true

module Admin
  class BaseController < ApplicationController
    layout "admin"

    before_action :authenticate_user!
    before_action :require_super_admin!

    private

    def require_super_admin!
      return if current_user.super_admin?

      redirect_to root_path, alert: "No tenés permiso para acceder a la consola de plataforma."
    end
  end
end
