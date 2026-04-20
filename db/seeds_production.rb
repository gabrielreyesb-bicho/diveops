# Seeds para producción
# Este script crea una agencia de ejemplo y un usuario owner

puts "🌱 Creando datos iniciales para producción..."

# Crear agencia
agency = Agency.find_or_create_by!(slug: "deepsoul") do |a|
  a.name = "Deepsoul"
  a.contact_email = "contact@deepsoul.com"
  a.phone = "+52 123 456 7890"
  a.website = "https://deepsoul.com"
  puts "✅ Agencia 'Deepsoul' creada"
end

puts "✅ Agencia encontrada/creada: #{agency.name} (slug: #{agency.slug})"

# Crear usuario owner
email = ENV["ADMIN_EMAIL"] || "gabriel@deepsoul.com"
password = ENV["ADMIN_PASSWORD"] || "password123"

user = User.find_or_create_by!(email: email) do |u|
  u.name = "Gabriel Reyes"
  u.agency = agency
  u.role = :owner
  u.password = password
  u.password_confirmation = password
  puts "✅ Usuario owner creado: #{email}"
end

puts "✅ Usuario encontrado/creado: #{user.name} (#{user.email})"
puts ""
puts "🎉 Datos iniciales creados exitosamente!"
puts ""
puts "Puedes acceder a:"
puts "  URL: https://diveops.onrender.com/staff"
puts "  Email: #{user.email}"
puts "  Password: #{password}"
puts ""
puts "⚠️  IMPORTANTE: Cambia la contraseña después de iniciar sesión"
