# frozen_string_literal: true

module Staff
  class BaseController < ApplicationController
    before_action :authenticate_user!

    helper Staff::RegistrationsHelper
    helper Staff::DiversHelper
  end
end
