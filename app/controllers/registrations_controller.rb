# frozen_string_literal: true

class RegistrationsController < ApplicationController
  include CatalogScoping

  before_action :authenticate_diver!

  # Aligned with catálogo visible: incluye +confirmed+ (programa confirmado por la agencia sigue admitiendo inscripciones hasta cupo).
  REGISTRATION_PROGRAM_STATUSES = %i[open pending_confirmation confirmed].freeze

  def create
    program = load_program_for_register!
    unless registrable_program?(program)
      redirect_to program_public_path(program), alert: "Este programa no acepta inscripciones en este momento."
      return
    end

    if current_diver.registrations.exists?(program: program)
      redirect_to program_public_path(program), alert: "Ya estás inscrito en este programa."
      return
    end

    status = program.registration_slots_available? ? :pending : :waitlisted

    begin
      Registration.create!(
        { diver: current_diver, program: program, status: status }.merge(utm_attributes_for_registration)
      )
    rescue ActiveRecord::RecordNotUnique
      redirect_to program_public_path(program), alert: "Ya estás inscrito en este programa."
      return
    end

    notice =
      if status == :pending
        "Inscripción recibida (pendiente de confirmación)."
      else
        "No hay cupo disponible; quedaste en lista de espera."
      end

    redirect_to program_public_path(program), notice: notice
  end

  private

  def program_public_path(program)
    program.is_a?(DiveTrip) ? trip_path(program) : course_path(program)
  end

  def load_program_for_register!
    case params[:program_type].to_s
    when "DiveTrip"
      catalog_agency!.dive_trips.find(params[:id])
    when "Course"
      catalog_agency!.courses.find(params[:id])
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  def registrable_program?(program)
    REGISTRATION_PROGRAM_STATUSES.any? { |s| program.public_send("program_#{s}?") }
  end
end
