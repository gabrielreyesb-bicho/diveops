# frozen_string_literal: true

module Staff
  class RegistrationsController < Staff::BaseController
    before_action :set_registration, only: %i[confirm waitlist cancel]

    def index
      @agency = current_agency
      @registrations = agency_registrations_scope
      @registrations = apply_filters(@registrations)
      @registrations = @registrations.includes(:diver, :program).order(created_at: :desc)
    end

    def confirm
      flash_key = nil
      flash_message = nil

      @registration.with_lock do
        program = @registration.program

        unless @registration.registration_pending? || @registration.registration_waitlisted?
          flash_key = :alert
          flash_message = "Solo se puede confirmar desde pendiente o lista de espera."
          next
        end

        if program.registration_confirmed.count >= program.max_capacity
          flash_key = :alert
          flash_message = "No hay cupo disponible."
          next
        end

        @registration.update!(status: :confirmed)
        program.sync_program_status_from_registrations!
        flash_key = :notice
        flash_message = "Inscripción confirmada."
      end

      redirect_to after_path, flash_key => flash_message
    end

    def waitlist
      flash_key = nil
      flash_message = nil

      @registration.with_lock do
        program = @registration.program

        unless @registration.registration_pending? || @registration.registration_confirmed?
          flash_key = :alert
          flash_message = "Solo se puede pasar a lista de espera desde pendiente o confirmada."
          next
        end

        @registration.update!(status: :waitlisted)
        program.sync_program_status_from_registrations!
        flash_key = :notice
        flash_message = "Inscripción en lista de espera."
      end

      redirect_to after_path, flash_key => flash_message
    end

    def cancel
      @registration.with_lock do
        program = @registration.program
        attrs = { status: :cancelled }
        attrs[:notes] = params[:notes] if params.key?(:notes)
        @registration.update!(attrs)
        program.sync_program_status_from_registrations!
      end

      redirect_to after_path, notice: "Inscripción cancelada."
    end

    private

    def set_registration
      @registration = agency_registrations_scope.find(params[:id])
    end

    def agency_registrations_scope
      agency = current_agency
      Registration.where(program_type: "DiveTrip", program_id: agency.dive_trip_ids).or(
        Registration.where(program_type: "Course", program_id: agency.course_ids)
      )
    end

    def apply_filters(scope)
      if params[:program_type].to_s.in?(%w[DiveTrip Course]) && params[:program_id].present?
        scope = scope.where(program_type: params[:program_type], program_id: params[:program_id])
      end
      if params[:status].present? && Registration.statuses.key?(params[:status].to_s)
        scope = scope.where(status: params[:status])
      end

      scope
    end

    def after_path
      request.referer.presence || staff_registrations_path
    end
  end
end
