module ApplicationHelper
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
end
