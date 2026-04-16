# frozen_string_literal: true

class DiveTripsController < ApplicationController
  include CatalogScoping

  before_action :set_dive_trip

  def show
    raise ActiveRecord::RecordNotFound unless program_visible_to_catalog?(@dive_trip)

    @going_divers = visible_going_divers(@dive_trip, viewer: (current_diver if diver_signed_in?))
  end

  private

  def set_dive_trip
    @agency = catalog_agency
    raise ActiveRecord::RecordNotFound if @agency.blank?

    @dive_trip = @agency.dive_trips.includes(photos: { image_attachment: :blob }).find(params[:id])
  end
end
