class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  include CapturesUtmToSession

  before_action :set_locale

  helper_method :current_user, :current_diver, :current_agency, :super_admin?

  def after_sign_in_path_for(resource)
    if resource.is_a?(User)
      return admin_root_path if resource.super_admin? && resource.agency_id.nil?

      return staff_root_path
    end

    if resource.is_a?(Diver)
      stored_location_for(resource) || programs_path
    else
      super
    end
  end

  private

  def set_locale
    I18n.locale = I18n.default_locale
  end

  # +authenticate_user!+ and +authenticate_diver!+ are provided by Devise for before_actions.

  def current_agency
    current_user&.agency
  end

  def super_admin?
    current_user&.super_admin? || false
  end
end
