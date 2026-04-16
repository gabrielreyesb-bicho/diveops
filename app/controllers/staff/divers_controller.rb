# frozen_string_literal: true

module Staff
  class DiversController < Staff::BaseController
    def index
      @divers = Diver.for_agency(current_agency).with_attached_avatar.order(:name)
    end

    def show
      @diver = Diver.for_agency(current_agency).find(params[:id])
      @registrations = @diver.registrations_for_agency(current_agency).includes(:program).order(created_at: :desc)
      @interests = @diver.interests_for_agency(current_agency).includes(:program).order(created_at: :desc)
    end
  end
end
