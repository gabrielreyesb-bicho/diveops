namespace :deepsoul do
  desc "Setup inicial de DeepSoul - crea agencia y usuario admin"
  task setup: :environment do
    puts "🌱 Configurando DeepSoul..."

    # Crear agencia
    agency = Agency.find_or_create_by!(slug: "deepsoul") do |a|
      a.name = "DeepSoul"
      a.contact_email = "contacto@deepsoul.com"
      a.phone = "+52 333 123 4567"
      a.website = "https://diveops.onrender.com"
      puts "✅ Agencia DeepSoul creada"
    end

    puts "✅ Agencia: #{agency.name} (ID: #{agency.id})"

    # Crear usuario admin
    email = "admin@deepsoul.com"
    password = "ChangeMe2026!"

    user = User.find_or_initialize_by(email: email)
    if user.new_record?
      user.name = "Admin DeepSoul"
      user.agency = agency
      user.role = :owner
      user.password = password
      user.password_confirmation = password
      user.save!
      puts "✅ Usuario admin creado: #{email}"
      puts "   Password: #{password}"
    else
      # Usuario ya existe, actualizar password
      user.password = password
      user.password_confirmation = password
      user.save!
      puts "✅ Usuario admin actualizado: #{email}"
      puts "   Password reseteado a: #{password}"
    end

    puts ""
    puts "🎉 Setup completado!"
    puts ""
    puts "Accede a:"
    puts "  URL: https://diveops.onrender.com/staff"
    puts "  Email: #{email}"
    puts "  Password: #{password}"
    puts ""
    puts "⚠️  CAMBIA LA CONTRASEÑA después de iniciar sesión"
  end
end
