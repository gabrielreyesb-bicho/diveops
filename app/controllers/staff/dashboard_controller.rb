# frozen_string_literal: true

module Staff
  class DashboardController < Staff::BaseController
    def index
      @program_items = []
      agency = current_agency
      return if agency.blank?

      trips = agency.dive_trips
        .includes(registrations: [ :diver, :payments ])
        .order(departure_date: :asc)
      courses = agency.courses
        .includes(registrations: [ :diver, :payments ])
        .order(start_date: :asc)

      items = []
      trips.each { |t| items << { kind: :trip, record: t, sort_date: t.departure_date } }
      courses.each { |c| items << { kind: :course, record: c, sort_date: c.start_date } }

      @program_items = items.sort_by do |i|
        [ i[:sort_date] || Date.new(3000, 1, 1), i[:kind].to_s ]
      end
    end
  end
end
