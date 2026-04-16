# frozen_string_literal: true

module Divers
  class ProfilesController < ApplicationController
    before_action :authenticate_diver!

    def show
      @recent_registrations = current_diver.registrations
        .includes(program: :agency)
        .order(created_at: :desc)
        .limit(3)
    end

    def edit
    end

    def update
      if params[:remove_avatar].to_s == "1"
        current_diver.avatar.purge
      end

      if current_diver.update(diver_params)
        redirect_to diver_profile_path, notice: "Perfil actualizado."
      else
        render :edit, status: :unprocessable_content
      end
    end

    private

    def diver_params
      p = params.require(:diver).permit(:name, :dive_count, :certification_level, :privacy, :avatar, :receive_diveops_emails)
      p[:dive_count] = nil if p[:dive_count].blank?
      p
    end
  end
end
