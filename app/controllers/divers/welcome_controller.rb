# frozen_string_literal: true

module Divers
  class WelcomeController < ApplicationController
    before_action :authenticate_diver!

    def show
      # Si el buzo ya tiene inscripciones, redirigir al catálogo (ya conoce la app)
      if current_diver.registrations.any?
        redirect_to programs_path
      end
    end
  end
end
