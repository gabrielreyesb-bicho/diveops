# frozen_string_literal: true

# One-click / enlace de baja (RFC 8058 compatible para clientes que envían POST).
class EmailPreferencesController < ApplicationController
  skip_forgery_protection only: :unsubscribe

  layout "application"

  def unsubscribe
    token = params[:token].to_s
    if token.blank?
      render :invalid_token, status: :unprocessable_entity
      return
    end

    diver = Diver.find_signed(token, purpose: :email_unsubscribe)
    if diver.nil?
      render :invalid_token, status: :unprocessable_entity
      return
    end

    diver.update!(receive_diveops_emails: false) if diver.receive_diveops_emails?
    @diver = diver
  end
end
