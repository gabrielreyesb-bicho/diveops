# frozen_string_literal: true

# Resend API key: set RESEND_API_KEY in the environment, or add under `resend: api_key:` via
# `bin/rails credentials:edit` (see config/credentials.yml.enc).
Resend.api_key = lambda {
  ENV["RESEND_API_KEY"].presence || Rails.application.credentials.dig(:resend, :api_key)
}
