# frozen_string_literal: true

module Staff
  module Courses
    class RegistrationsController < Staff::BaseController
      before_action :set_course

      def index
        @registrations = @course.registrations.includes(:diver, :program).order(created_at: :desc)
        @index_scope_title = "Curso: #{@course.title}"
        render "staff/registrations/index"
      end

      private

      def set_course
        @course = current_agency.courses.find(params[:course_id])
      end
    end
  end
end
