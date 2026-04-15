# frozen_string_literal: true

module Divers
  class PasswordsController < Devise::PasswordsController
    layout "auth"
  end
end
