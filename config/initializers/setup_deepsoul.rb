# Setup automático de DeepSoul en producción
# Este initializer crea la agencia y usuario owner si no existen

Rails.application.config.after_initialize do
  if Rails.env.production? && ActiveRecord::Base.connection.table_exists?('agencies')
    begin
      # Crear agencia DeepSoul si no existe
      agency = Agency.find_or_create_by!(slug: "deepsoul") do |a|
        a.name = "DeepSoul"
        a.contact_email = "contacto@deepsoul.com"
        a.phone = "+52 333 123 4567"
        a.website = "https://diveops.onrender.com"
        Rails.logger.info "✅ Agencia DeepSoul creada automáticamente"
      end

      # Crear usuario owner si no existe
      if User.where(agency: agency).none?
        User.create!(
          email: "admin@deepsoul.com",
          name: "Admin DeepSoul",
          agency: agency,
          role: :owner,
          password: "ChangeMe2026!",
          password_confirmation: "ChangeMe2026!"
        )
        Rails.logger.info "✅ Usuario admin de DeepSoul creado automáticamente"
        Rails.logger.info "   Email: admin@deepsoul.com"
        Rails.logger.info "   Password: ChangeMe2026!"
        Rails.logger.info "   ⚠️  CAMBIA LA CONTRASEÑA INMEDIATAMENTE"
      end
    rescue => e
      Rails.logger.error "❌ Error en setup de DeepSoul: #{e.message}"
    end
  end
end
