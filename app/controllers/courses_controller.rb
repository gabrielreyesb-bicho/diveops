# frozen_string_literal: true

class CoursesController < ApplicationController
  include CatalogScoping

  before_action :set_course

  def show
    raise ActiveRecord::RecordNotFound unless program_visible_to_catalog?(@course)

    @going_divers = visible_going_divers(@course, viewer: (current_diver if diver_signed_in?))
  end

  private

  def set_course
    @agency = catalog_agency
    raise ActiveRecord::RecordNotFound if @agency.blank?

    @course = @agency.courses.includes(photos: { image_attachment: :blob }).find(params[:id])
  end
end
