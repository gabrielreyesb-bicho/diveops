# frozen_string_literal: true

module Staff
  class DiveTripsController < Staff::BaseController
    before_action :set_dive_trip, only: %i[show edit update destroy publish confirm cancel]

    def index
      @dive_trips = current_agency.dive_trips.order(departure_date: :desc, created_at: :desc)
    end

    def show
    end

    def new
      @dive_trip = current_agency.dive_trips.build(status: :planning)
    end

    def create
      @dive_trip = current_agency.dive_trips.build(dive_trip_params.except(:images))
      if @dive_trip.save
        attach_photos(@dive_trip, dive_trip_params[:images])
        redirect_to staff_dive_trip_path(@dive_trip), notice: "Viaje creado."
      else
        render :new, status: :unprocessable_content
      end
    end

    def edit
    end

    def update
      if @dive_trip.update(dive_trip_params.except(:images))
        attach_photos(@dive_trip, dive_trip_params[:images])
        redirect_to staff_dive_trip_path(@dive_trip), notice: "Viaje actualizado."
      else
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      @dive_trip.destroy
      redirect_to staff_dive_trips_path, notice: "Viaje eliminado."
    end

    def publish
      unless @dive_trip.program_planning?
        redirect_to staff_dive_trip_path(@dive_trip), alert: "Solo se puede publicar desde estado planeación."
        return
      end
      @dive_trip.update!(status: :open)
      redirect_to staff_dive_trip_path(@dive_trip), notice: "Publicado (abierto a inscripciones)."
    end

    def confirm
      unless @dive_trip.program_pending_confirmation?
        redirect_to staff_dive_trip_path(@dive_trip), alert: "Solo se puede confirmar desde estado pendiente de confirmación."
        return
      end
      @dive_trip.update!(status: :confirmed)
      redirect_to staff_dive_trip_path(@dive_trip), notice: "Programa confirmado."
    end

    def cancel
      reason = params[:cancellation_reason].to_s.strip
      if reason.blank?
        redirect_to staff_dive_trip_path(@dive_trip), alert: "Indica el motivo de cancelación."
        return
      end
      @dive_trip.update!(status: :cancelled, cancellation_reason: reason)
      redirect_to staff_dive_trip_path(@dive_trip), notice: "Programa cancelado."
    end

    private

    def set_dive_trip
      @dive_trip = current_agency.dive_trips.find(params[:id])
    end

    def dive_trip_params
      params.require(:dive_trip).permit(
        :title,
        :destination,
        :departure_date,
        :return_date,
        :max_capacity,
        :min_capacity,
        :base_price,
        :status,
        :cancellation_reason,
        :description,
        :requirements,
        :itinerary,
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
