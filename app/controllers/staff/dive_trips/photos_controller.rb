# frozen_string_literal: true

module Staff
  module DiveTrips
    class PhotosController < Staff::BaseController
      before_action :set_dive_trip

      def destroy
        photo = @dive_trip.photos.find(params[:id])
        photo.destroy
        redirect_to staff_dive_trip_path(@dive_trip), notice: "Foto eliminada."
      end

      private

      def set_dive_trip
        @dive_trip = current_agency.dive_trips.find(params[:dive_trip_id])
      end
    end
  end
end
