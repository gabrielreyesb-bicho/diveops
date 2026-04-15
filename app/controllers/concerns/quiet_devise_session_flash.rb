# frozen_string_literal: true

# Skips Devise's default flash notices on sign in, sign out, and "already signed out".
module QuietDeviseSessionFlash
  extend ActiveSupport::Concern

  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource)
  end

  def destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    yield if block_given?
    respond_to_on_destroy(non_navigational_status: :no_content)
  end

  private

  def verify_signed_out_user
    respond_to_on_destroy(non_navigational_status: :unauthorized) if all_signed_out?
  end
end
