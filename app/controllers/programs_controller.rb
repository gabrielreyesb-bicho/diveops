# frozen_string_literal: true

class ProgramsController < ApplicationController
  include CatalogScoping

  def index
    @agency = catalog_agency
    return if @agency.blank?

    status_values = CatalogScoping::CATALOG_STATUSES.map { |s| DiveTrip.statuses[s.to_s] }
    trips = @agency.dive_trips.where(status: status_values)
    courses = @agency.courses.where(status: status_values)

    trips, courses = apply_type_filter(trips, courses)
    trips, courses = apply_month_filter(trips, courses)
    trips, courses = apply_status_filter(trips, courses)

    @program_items = merge_and_sort(trips, courses)
    @card_registrations = card_registrations_index_for(@program_items)
  end

  private

  def apply_type_filter(trips, courses)
    case params[:type]
    when "trip"
      [ trips, courses.none ]
    when "course"
      [ trips.none, courses ]
    else
      [ trips, courses ]
    end
  end

  def apply_month_filter(trips, courses)
    return [ trips, courses ] if params[:month].blank?

    year, month = params[:month].to_s.split("-").map(&:to_i)
    return [ trips, courses ] if year.blank? || month.blank?

    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month
    [
      trips.where(departure_date: start_date..end_date),
      courses.where(start_date: start_date..end_date)
    ]
  end

  def apply_status_filter(trips, courses)
    key = params[:status].to_s.presence
    return [ trips, courses ] if key.blank?
    return [ trips, courses ] unless DiveTrip.statuses.key?(key) && Course.statuses.key?(key)

    value = DiveTrip.statuses[key]
    [
      trips.where(status: value),
      courses.where(status: value)
    ]
  end

  def merge_and_sort(trips, courses)
    items = []
    trips.includes(:rich_text_description, photos: { image_attachment: :blob }).find_each do |trip|
      items << { kind: :trip, record: trip, sort_date: trip.departure_date }
    end
    courses.includes(:rich_text_description, photos: { image_attachment: :blob }).find_each do |course|
      items << { kind: :course, record: course, sort_date: course.start_date }
    end
    items.sort_by { |i| [ i[:sort_date] || Date.new(3000, 1, 1), i[:kind].to_s ] }
  end
end
