# frozen_string_literal: true

module Staff
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_agency_for_staff_panel!

    helper Staff::RegistrationsHelper
    helper Staff::DiversHelper

    private

    def ensure_agency_for_staff_panel!
      return if current_user.agency.present?

      redirect_to admin_root_path, alert: "Tu cuenta no está asociada a una agencia. Usá la consola de plataforma para gestionar agencias."
    end
  end
end
