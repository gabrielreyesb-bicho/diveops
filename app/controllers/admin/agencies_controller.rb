# frozen_string_literal: true

module Admin
  class AgenciesController < Admin::BaseController
    before_action :set_agency, only: [ :show, :edit, :update, :destroy ]

    def index
      @agencies = Agency.order(:name).includes(:users)
    end

    def show
    end

    def new
      @agency = Agency.new
    end

    def create
      @agency = Agency.new(agency_params)
      if @agency.save
        redirect_to admin_agency_path(@agency), notice: "La agencia se creó correctamente."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @agency.update(agency_params)
        redirect_to admin_agency_path(@agency), notice: "Los datos de la agencia se actualizaron."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @agency.destroy
        redirect_to admin_agencies_path, notice: "La agencia se eliminó."
      else
        redirect_to admin_agency_path(@agency), alert: @agency.errors.full_messages.to_sentence.presence || "No se pudo eliminar la agencia."
      end
    end

    private

    def set_agency
      @agency = Agency.find(params[:id])
    end

    def agency_params
      params.require(:agency).permit(:name, :slug, :contact_email, :logo)
    end
  end
end
