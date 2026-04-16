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

  # Buzos confirmados visibles según privacidad del perfil y si el visitante está inscrito al mismo programa.
  def visible_going_divers(program, viewer: nil)
    confirmed = program.registrations.registration_confirmed.includes(diver: { avatar_attachment: :blob })
    divers = confirmed.map(&:diver).uniq
    viewer_enrolled = viewer.is_a?(Diver) &&
      program.registrations.registration_confirmed.exists?(diver: viewer)

    visible = divers.select do |d|
      next false if d.profile_private?
      next true if d.profile_public?

      viewer_enrolled
    end

    visible.sort_by { |d| d.name.to_s.downcase }
  end

  def public_going_divers(program)
    visible_going_divers(program, viewer: nil)
  end

  # Hash [ program_type, program_id ] => Registration para tarjetas del catálogo cuando el buzo está logueado.
  def card_registrations_index_for(items)
    return {} unless diver_signed_in? && items.present?

    programs = items.map { |i| i[:record] }
    current_diver.registrations.where(program: programs).index_by { |r| [ r.program_type, r.program_id ] }
  end
end
