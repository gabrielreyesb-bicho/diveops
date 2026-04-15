# frozen_string_literal: true

module Divers
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2
      auth = request.env["omniauth.auth"]
      @diver = Diver.from_google_oauth2(auth)

      if @diver.persisted? && @diver.errors.empty?
        sign_in_and_redirect @diver, event: :authentication
      else
        redirect_to new_diver_session_path,
                    alert: omniauth_error_message(@diver)
      end
    end

    def failure
      redirect_to new_diver_session_path, alert: failure_message
    end

    private

    def omniauth_error_message(diver)
      diver.errors.full_messages.presence&.join(", ") || failure_message
    end
  end
end
