# frozen_string_literal: true

module Divers
  class SessionsController < Devise::SessionsController
    include QuietDeviseSessionFlash

    layout "auth"
  end
end
