# frozen_string_literal: true

module Staff
  class UsersController < Staff::BaseController
    before_action :set_user, only: [ :edit, :update, :destroy ]

    def index
      @users = current_agency.users.with_attached_avatar.order(role: :asc, name: :asc)
    end

    def new
      @user = current_agency.users.build(role: :staff)
    end

    def create
      @user = current_agency.users.build(user_params_create)
      @user.role = :staff if @user.role.blank?
      if @user.save
        redirect_to staff_users_path, notice: "Se agregó a #{@user.name} al equipo."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if demoting_last_owner?
        @user.errors.add(:base, "Debe haber al menos un titular de la agencia.")
        render :edit, status: :unprocessable_entity
        return
      end

      if @user.update(user_params_update)
        redirect_to staff_users_path, notice: "Los datos de #{@user.name} se actualizaron."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if sole_owner_in_agency?(@user)
        redirect_to staff_users_path, alert: "No podés eliminar al único titular de la agencia. Designá otro titular antes."
        return
      end

      name = @user.name
      if @user.destroy
        redirect_to staff_users_path, notice: "#{name} ya no forma parte del equipo."
      else
        redirect_to staff_users_path, alert: @user.errors.full_messages.to_sentence.presence || "No se pudo eliminar al usuario."
      end
    end

    private

    def set_user
      @user = current_agency.users.find(params[:id])
    end

    def user_params_create
      p = params.require(:user).permit(:name, :email, :role, :password, :password_confirmation)
      p.delete(:role) unless current_user.owner?
      p
    end

    def user_params_update
      p = params.require(:user).permit(:name, :email, :role, :password, :password_confirmation)
      p.delete(:role) unless current_user.owner?
      if p[:password].blank?
        p.delete(:password)
        p.delete(:password_confirmation)
      end
      p
    end

    def demoting_last_owner?
      return false unless @user.owner?

      new_role = user_params_update[:role].presence || @user.role
      new_role.to_s != "owner" && current_agency.users.where(role: :owner).count == 1
    end

    def sole_owner_in_agency?(user)
      user.owner? && current_agency.users.where(role: :owner).count == 1
    end
  end
end
