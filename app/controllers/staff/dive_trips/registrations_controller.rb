# frozen_string_literal: true

module Staff
  module DiveTrips
    class RegistrationsController < Staff::BaseController
      before_action :set_dive_trip

      def index
        @registrations = @dive_trip.registrations.includes(:diver, :program).order(created_at: :desc)
        @index_scope_title = "Viaje: #{@dive_trip.title}"
        render "staff/registrations/index"
      end

      private

      def set_dive_trip
        @dive_trip = current_agency.dive_trips.find(params[:dive_trip_id])
      end
    end
  end
end
