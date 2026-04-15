# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

Agency.find_or_create_by!(slug: "deepsoul") do |agency|
  agency.name = "Deepsoul"
  agency.contact_email = "contact@deepsoul.example"
end
