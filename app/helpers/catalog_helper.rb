# frozen_string_literal: true

module CatalogHelper
  # Plain-text preview of Action Text description for catalog cards (no HTML).
  def program_card_description_preview(program, length: 200)
    desc = program.try(:description)
    return nil unless desc&.body&.present?

    plain = desc.body.to_plain_text.to_s.squish
    return nil if plain.blank?

    truncate(plain, length: length, omission: "…", separator: " ")
  rescue StandardError
    nil
  end

  def program_status_badge_class(status_key)
    case status_key.to_s
    when "open"
      "border border-caribe/50 bg-caribe/20 text-abismo"
    when "confirmed"
      "border border-oceano/40 bg-oceano/15 text-abismo"
    when "pending_confirmation"
      "border border-arrecife bg-arrecife/40 text-abismo"
    when "full"
      "border border-abismo/15 bg-abismo/10 text-abismo"
    when "planning"
      "border border-arrecife/60 bg-espuma text-profundo"
    when "cancelled"
      "border border-coral/40 bg-coral/15 text-abismo"
    else
      "border border-arrecife/50 bg-espuma text-abismo"
    end
  end

  # First photo whose file exists and is an image (avoids broken <img> when DB says attached but file is missing).
  def primary_program_image(program)
    program.photos.includes(image_attachment: :blob).order(:position).each do |photo|
      next unless program_image_usable?(photo.image)

      return photo.image
    end

    nil
  end

  def program_image_usable?(attachment)
    return false unless attachment.attached?

    blob = attachment.blob
    return false unless blob.persisted?
    return false unless blob.content_type.to_s.start_with?("image/")

    blob.service.exist?(blob.key)
  rescue StandardError
    false
  end

  def going_sentence(divers, program_label: "este programa")
    return if divers.blank?

    names = divers.map(&:name)
    case names.size
    when 1
      "#{names.first} va a #{program_label}."
    when 2
      "#{names[0]} y #{names[1]} van a #{program_label}."
    else
      rest = names.size - 2
      person_word = rest == 1 ? "persona" : "personas"
      "#{names[0]}, #{names[1]} y #{rest} #{person_word} más van a #{program_label}."
    end
  end

  def catalog_signup_path_for_actions
    new_diver_registration_path
  end

  def catalog_month_filter_options
    [ [ "Todos los meses", "" ] ] + (0..18).map do |i|
      d = Date.current.beginning_of_month + i.months
      [ d.strftime("%Y-%m"), d.strftime("%Y-%m") ]
    end
  end

  def catalog_status_filter_options
    [
      [ "Todos los estados", "" ],
      [ "Abierto", "open" ],
      [ "Confirmado", "confirmed" ],
      [ "Pendiente de confirmación", "pending_confirmation" ]
    ]
  end

  def registration_status_badge_class(status_key)
    case status_key.to_s
    when "pending"
      "border border-arrecife bg-arrecife/40 text-abismo"
    when "confirmed"
      "border border-oceano/40 bg-oceano/15 text-abismo"
    when "waitlisted"
      "border border-abismo/15 bg-abismo/10 text-abismo"
    when "cancelled"
      "border border-coral/40 bg-coral/15 text-abismo"
    else
      "border border-arrecife/50 bg-espuma text-abismo"
    end
  end

  def program_accepts_self_registration?(program)
    program.program_open? || program.program_pending_confirmation? || program.program_confirmed?
  end
end
