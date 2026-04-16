# frozen_string_literal: true

class DiverMailer < ApplicationMailer
  # Signed ID expiry for unsubscribe links (long-lived; revocable from perfil).
  UNSUBSCRIBE_TOKEN_EXPIRES_IN = 10.years

  def welcome(diver)
    @diver = diver
    return unless diver.receive_diveops_emails?

    attach_list_unsubscribe_headers!(diver)
    mail(to: diver.email, subject: "Bienvenido a Deepsoul")
  end

  def registration_received(registration)
    @registration = registration
    @program = registration.program
    diver = registration.diver
    return unless diver.receive_diveops_emails?

    attach_list_unsubscribe_headers!(diver)
    mail(to: diver.email, subject: "Recibimos tu inscripción — #{program_display_name(@program)}")
  end

  def registration_confirmed(registration)
    @registration = registration
    @program = registration.program
    diver = registration.diver
    return unless diver.receive_diveops_emails?

    attach_list_unsubscribe_headers!(diver)
    mail(to: diver.email, subject: "Tu inscripción está confirmada — #{program_display_name(@program)}")
  end

  def registration_waitlisted(registration)
    @registration = registration
    @program = registration.program
    diver = registration.diver
    return unless diver.receive_diveops_emails?

    attach_list_unsubscribe_headers!(diver)
    mail(to: diver.email, subject: "Lista de espera — #{program_display_name(@program)}")
  end

  def registration_cancelled(registration, reason: nil)
    @registration = registration
    @program = registration.program
    @reason = reason
    diver = registration.diver
    return unless diver.receive_diveops_emails?

    attach_list_unsubscribe_headers!(diver)
    mail(to: diver.email, subject: "Inscripción cancelada — #{program_display_name(@program)}")
  end

  # Anuncio de un viaje o curso recién publicado (estado abierto) en el catálogo.
  def new_public_program(diver, program)
    @diver = diver
    @program = program
    @agency = program.agency
    @program_url = program_public_url(program)
    return unless diver.receive_diveops_emails?

    attach_list_unsubscribe_headers!(diver)
    kind = program_kind_label(program)
    mail(
      to: diver.email,
      subject: "Nuevo #{kind.downcase} en Deepsoul — #{program_display_name(program)}"
    )
  end

  private

  def attach_list_unsubscribe_headers!(diver)
    token = diver.signed_id(purpose: :email_unsubscribe, expires_in: UNSUBSCRIBE_TOKEN_EXPIRES_IN)
    @unsubscribe_url = email_unsubscribe_url(token: token)
    headers["List-Unsubscribe"] = "<#{@unsubscribe_url}>"
    headers["List-Unsubscribe-Post"] = "List-Unsubscribe=One-Click"
  end
end
