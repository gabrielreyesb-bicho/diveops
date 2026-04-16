module ApplicationHelper
  DIVER_AVATAR_PIXELS = { sm: 32, md: 40, lg: 96, nav: 44 }.freeze

  # Enum labels (via I18n) — defined here so every view has them even when
  # `include_all_helpers` is false for a controller.
  def program_status_text(program)
    I18n.t(
      "activerecord.enums.#{program.model_name.i18n_key}.status.#{program.status}",
      default: program.status.to_s.humanize
    )
  end

  def registration_status_text(registration)
    I18n.t(
      "activerecord.enums.registration.status.#{registration.status}",
      default: registration.status.to_s.humanize
    )
  end

  def diver_certification_level_text(diver)
    I18n.t(
      "activerecord.enums.diver.certification_level.#{diver.certification_level}",
      default: diver.certification_level.to_s.humanize
    )
  end

  def diver_privacy_label(diver)
    I18n.t(
      "activerecord.enums.diver.privacy.#{diver.privacy}",
      default: diver.privacy.to_s.humanize
    )
  end

  def diver_privacy_help_text(diver)
    I18n.t("diver.privacy_help.#{diver.privacy}", default: "")
  end

  # Rutas públicas del catálogo (`/trips/:id`, `/courses/:id`). No usar `polymorphic_url(program)`:
  # el modelo se llama DiveTrip y Rails buscaría `dive_trip_url`, que no existe.
  def public_program_path(program)
    program.is_a?(DiveTrip) ? trip_path(program) : course_path(program)
  end

  def public_program_url(program)
    program.is_a?(DiveTrip) ? trip_url(program) : course_url(program)
  end

  # Foto propia (Active Storage) o imagen genérica (`avatar_buzo.png`).
  # Contenedor cuadrado + <img> absolute inset-0: evita el preflight `img{height:auto}` y rarezas con
  # `backdrop-blur` en el <nav> (bandas / “algo encima” del círculo).
  def diver_avatar_for(diver, variant: :md, extra_class: "")
    px = DIVER_AVATAR_PIXELS[variant] || 40
    size_classes = case variant
                   when :sm then "h-8 w-8"
                   when :nav then "h-11 w-11"
                   when :lg then "h-24 w-24"
                   else "h-10 w-10"
                   end

    wrapper_class = "relative inline-block shrink-0 overflow-hidden rounded-full #{size_classes} #{extra_class}".strip
    img_class = "pointer-events-none absolute inset-0 box-border h-full w-full object-cover"
    img_style = "max-width:none;max-height:none"

    inner = if diver_avatar_storage_usable?(diver.avatar)
              src = diver.avatar.variable? ? diver.avatar.variant(resize_to_fill: [ px, px ]) : diver.avatar
              image_tag src, class: img_class, style: img_style, alt: ""
            else
              image_tag "avatar_buzo.png",
                        class: img_class,
                        style: img_style,
                        alt: "",
                        decoding: "async"
            end

    content_tag(:span, inner, class: wrapper_class, style: "width:#{px}px;height:#{px}px;isolation:isolate")
  end

  private

  def diver_avatar_storage_usable?(attachment)
    return false unless attachment.attached?

    blob = attachment.blob
    return false unless blob.persisted?
    return false unless blob.content_type.to_s.start_with?("image/")

    blob.service.exist?(blob.key)
  rescue StandardError
    false
  end
end
