# frozen_string_literal: true

# Sin acceso a consola (p. ej. Render sin shell): asigná super admin desde el panel de la app.
#
# En Render → tu servicio → Environment:
#   SUPER_ADMIN_EMAIL=tu-correo@ejemplo.com
# Opcional (cuenta solo plataforma, sin panel de agencia):
#   SUPER_ADMIN_REMOVE_AGENCY=true
# Después de un deploy exitoso, borrá esas variables y volvé a desplegar para no depender del arranque.
#
# Migraciones: en Render → Settings → Build & Deploy → Release command:
#   bundle exec rails db:migrate
# (o el equivalente en tu proveedor; debe ejecutarse antes de levantar el web process.)
#
Rails.application.config.after_initialize do
  next unless Rails.env.production?

  email = ENV["SUPER_ADMIN_EMAIL"].presence
  next unless email

  begin
    user = User.find_by(email: email)
    unless user
      Rails.logger.warn "[SuperAdmin] No hay usuario con email #{email.inspect} (SUPER_ADMIN_EMAIL)."
      next
    end

    remove_agency = ENV["SUPER_ADMIN_REMOVE_AGENCY"].to_s == "true"

    user.super_admin = true
    user.agency_id = nil if remove_agency && user.agency_id.present?

    next unless user.changed?

    user.save!
    Rails.logger.info "[SuperAdmin] Usuario #{email} actualizado (super_admin=true, agency_id=#{user.agency_id.inspect})."
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "[SuperAdmin] No se pudo guardar: #{e.record.errors.full_messages.join(', ')}"
  rescue StandardError => e
    Rails.logger.error "[SuperAdmin] #{e.class}: #{e.message}"
  end
end
