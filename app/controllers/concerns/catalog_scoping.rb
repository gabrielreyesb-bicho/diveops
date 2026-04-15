# frozen_string_literal: true

# Catálogo público: una sola agencia por ahora (la primera). Más adelante: subdominio o slug.
module CatalogScoping
  extend ActiveSupport::Concern

  # Estados visibles en catálogo público (misma regla en home destacados y /programs).
  CATALOG_STATUSES = %i[open confirmed pending_confirmation].freeze

  private

  def catalog_agency
    @catalog_agency ||= Agency.order(:id).first
  end

  def catalog_agency!
    catalog_agency || raise(ActiveRecord::RecordNotFound)
  end

  def program_visible_to_catalog?(program)
    CATALOG_STATUSES.any? { |s| program.public_send("program_#{s}?") }
  end

  def public_going_divers(program)
    program.registrations
      .registration_confirmed
      .joins(:diver)
      .merge(Diver.where(privacy: :public))
      .includes(:diver)
      .order("divers.name ASC")
      .map(&:diver)
  end

  # Hash [ program_type, program_id ] => Registration para tarjetas del catálogo cuando el buzo está logueado.
  def card_registrations_index_for(items)
    return {} unless diver_signed_in? && items.present?

    programs = items.map { |i| i[:record] }
    current_diver.registrations.where(program: programs).index_by { |r| [ r.program_type, r.program_id ] }
  end
end
