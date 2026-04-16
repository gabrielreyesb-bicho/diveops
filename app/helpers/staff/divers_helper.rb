# frozen_string_literal: true

module Staff
  module DiversHelper
    def staff_program_path_for(program)
      program.is_a?(DiveTrip) ? staff_dive_trip_path(program) : staff_course_path(program)
    end

    def staff_diver_provider_label(diver)
      diver.google? ? "Google" : "Correo y contraseña"
    end
  end
end
