# frozen_string_literal: true

# Stores utm_* query params in session for attribution on registration.
module CapturesUtmToSession
  extend ActiveSupport::Concern

  UTM_KEYS = %w[utm_source utm_medium utm_campaign utm_content].freeze

  included do
    before_action :capture_utm_params_to_session
  end

  private

  def capture_utm_params_to_session
    return unless request.get?
    return unless UTM_KEYS.any? { |k| params[k].present? }

    session[:utm] ||= {}
    UTM_KEYS.each do |k|
      session[:utm][k] = params[k].to_s if params[k].present?
    end
  end

  def utm_attributes_for_registration
    h = session[:utm].presence || {}
    {
      utm_source: h["utm_source"],
      utm_medium: h["utm_medium"],
      utm_campaign: h["utm_campaign"],
      utm_content: h["utm_content"]
    }.reject { |_, v| v.blank? }
  end
end
