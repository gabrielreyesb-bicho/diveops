# frozen_string_literal: true

module Staff
  class CoursesController < Staff::BaseController
    before_action :set_course, only: %i[show edit update destroy publish confirm cancel]

    def index
      @courses = current_agency.courses.order(start_date: :desc, created_at: :desc)
    end

    def show
    end

    def new
      @course = current_agency.courses.build(status: :planning)
    end

    def create
      @course = current_agency.courses.build(course_params.except(:images))
      if @course.save
        attach_photos(@course, course_params[:images])
        redirect_to staff_course_path(@course), notice: "Curso creado."
      else
        render :new, status: :unprocessable_content
      end
    end

    def edit
    end

    def update
      if @course.update(course_params.except(:images))
        attach_photos(@course, course_params[:images])
        redirect_to staff_course_path(@course), notice: "Curso actualizado."
      else
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      @course.destroy
      redirect_to staff_courses_path, notice: "Curso eliminado."
    end

    def publish
      unless @course.program_planning?
        redirect_to staff_course_path(@course), alert: "Solo se puede publicar desde estado planeación."
        return
      end
      @course.update!(status: :open)
      redirect_to staff_course_path(@course), notice: "Publicado (abierto a inscripciones)."
    end

    def confirm
      unless @course.program_pending_confirmation?
        redirect_to staff_course_path(@course), alert: "Solo se puede confirmar desde estado pendiente de confirmación."
        return
      end
      @course.update!(status: :confirmed)
      redirect_to staff_course_path(@course), notice: "Programa confirmado."
    end

    def cancel
      reason = params[:cancellation_reason].to_s.strip
      if reason.blank?
        redirect_to staff_course_path(@course), alert: "Indica el motivo de cancelación."
        return
      end
      @course.update!(status: :cancelled, cancellation_reason: reason)
      redirect_to staff_course_path(@course), notice: "Programa cancelado."
    end

    private

    def set_course
      @course = current_agency.courses.find(params[:id])
    end

    def course_params
      params.require(:course).permit(
        :title,
        :certification_granted,
        :prerequisite_certification,
        :start_date,
        :end_date,
        :duration_description,
        :max_capacity,
        :min_capacity,
        :base_price,
        :status,
        :cancellation_reason,
        :description,
        images: []
      )
    end

    def attach_photos(record, files)
      return if files.blank?

      files = Array(files).reject(&:blank?)
      max_pos = record.photos.maximum(:position) || -1
      files.each_with_index do |file, i|
        next unless file.respond_to?(:read)

        record.photos.create!(position: max_pos + 1 + i, image: file)
      end
    end
  end
end
