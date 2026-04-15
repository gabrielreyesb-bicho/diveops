# frozen_string_literal: true

class HomeController < ApplicationController
  include CatalogScoping

  before_action :redirect_staff_to_dashboard, only: :index

  def index
    @agency = catalog_agency
    return if @agency.blank?

    status_values = CatalogScoping::CATALOG_STATUSES.map { |s| DiveTrip.statuses[s.to_s] }
    trips = @agency.dive_trips.where(status: status_values).includes(:rich_text_description, photos: { image_attachment: :blob })
    courses = @agency.courses.where(status: status_values).includes(:rich_text_description, photos: { image_attachment: :blob })

    items = []
    trips.find_each { |t| items << { kind: :trip, record: t, sort_date: t.departure_date } }
    courses.find_each { |c| items << { kind: :course, record: c, sort_date: c.start_date } }
    @featured = items.sort_by { |i| [ i[:sort_date] || Date.new(3000, 1, 1), i[:kind].to_s ] }.first(3)
    @card_registrations = card_registrations_index_for(@featured)
  end

  private

  def redirect_staff_to_dashboard
    redirect_to staff_root_path if user_signed_in? && current_agency.present?
  end
end
