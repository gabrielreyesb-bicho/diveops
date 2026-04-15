# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    include QuietDeviseSessionFlash

    layout "auth"
  end
end
