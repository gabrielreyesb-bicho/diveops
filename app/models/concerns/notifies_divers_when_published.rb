# frozen_string_literal: true

# Cuando un programa (viaje o curso) pasa a estado +open+, avisa por correo a los buzos
# que aceptan correos de DiveOps. Así no se notifica un borrador en planeación.
module NotifiesDiversWhenPublished
  extend ActiveSupport::Concern

  included do
    after_commit :enqueue_broadcast_if_newly_open, on: %i[create update]
  end

  private

  def enqueue_broadcast_if_newly_open
    return unless program_open?

    change = saved_change_to_status
    return if change.blank?

    before, after = change
    # saved_change_to_* devuelve etiquetas de enum como string ("open"), no el entero en BD.
    return unless after.to_s == "open"
    return if before.present? && before.to_s == "open"

    BroadcastNewProgramToDiversJob.perform_later(self)
  end
end
