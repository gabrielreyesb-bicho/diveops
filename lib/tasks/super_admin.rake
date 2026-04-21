# frozen_string_literal: true

namespace :super_admin do
  desc "Marca un usuario del panel como super administrador de plataforma. Uso: bin/rails super_admin:promote[correo@ejemplo.com]"
  task :promote, [ :email ] => :environment do |_t, args|
    email = args[:email].to_s.strip
    abort "Uso: bin/rails super_admin:promote[correo@ejemplo.com]" if email.blank?

    user = User.find_by(email: email)
    abort "No existe un usuario con el correo #{email.inspect}." unless user

    user.update!(super_admin: true)
    puts "Listo: #{email} tiene rol super admin (super_admin: true)."
    puts "Opcional: quitar la agencia con user.update!(agency_id: nil) en consola para una cuenta solo plataforma."
  end
end
