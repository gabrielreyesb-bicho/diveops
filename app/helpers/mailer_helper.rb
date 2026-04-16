# frozen_string_literal: true

module MailerHelper
  def program_display_name(program)
    case program
    when DiveTrip
      "#{program.title} — #{program.destination}"
    when Course
      program.title
    else
      program.try(:title).to_s
    end
  end

  def program_date_range(program)
    case program
    when DiveTrip
      "#{program.departure_date.strftime('%d/%m/%Y')} – #{program.return_date.strftime('%d/%m/%Y')}"
    when Course
      "#{program.start_date.strftime('%d/%m/%Y')} – #{program.end_date.strftime('%d/%m/%Y')}"
    else
      ""
    end
  end

  def registration_status_label(registration)
    I18n.t("activerecord.enums.registration.status.#{registration.status}")
  end

  def program_kind_label(program)
    program.is_a?(DiveTrip) ? "Viaje" : "Curso"
  end

  def program_public_url(program)
    program.is_a?(DiveTrip) ? trip_url(program) : course_url(program)
  end
end
