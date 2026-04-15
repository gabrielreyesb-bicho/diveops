# frozen_string_literal: true

module Staff
  module Courses
    class PhotosController < Staff::BaseController
      before_action :set_course

      def destroy
        photo = @course.photos.find(params[:id])
        photo.destroy
        redirect_to staff_course_path(@course), notice: "Foto eliminada."
      end

      private

      def set_course
        @course = current_agency.courses.find(params[:course_id])
      end
    end
  end
end
