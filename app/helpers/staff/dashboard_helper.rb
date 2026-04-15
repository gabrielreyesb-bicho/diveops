# frozen_string_literal: true

module Staff
  module DashboardHelper
    include CatalogHelper

    def staff_program_show_path(item)
      program = item[:record]
      item[:kind] == :trip ? staff_dive_trip_path(program) : staff_course_path(program)
    end

    def staff_program_edit_path(item)
      program = item[:record]
      item[:kind] == :trip ? edit_staff_dive_trip_path(program) : edit_staff_course_path(program)
    end

    # :planning | :cancelled | :active
    def staff_dashboard_program_mode(program)
      return :planning if program.program_planning?
      return :cancelled if program.program_cancelled?

      :active
    end

    # Plain-language summary of payments for one registration (completed vs pending totals).
    def staff_registration_payment_summary(registration)
      completed = registration.payments.payment_completed.sum(:amount)
      pending = registration.payments.payment_pending.sum(:amount)
      refunded = registration.payments.payment_refunded.sum(:amount)

      parts = []
      parts << "#{number_to_currency(completed, unit: '$', precision: 2)} pagado" if completed.positive?
      parts << "#{number_to_currency(pending, unit: '$', precision: 2)} pendiente" if pending.positive?
      parts << "#{number_to_currency(refunded, unit: '$', precision: 2)} reembolsado" if refunded.positive?

      return "Sin pagos registrados" if parts.empty?

      parts.join(" · ")
    end

    def staff_registrations_for_table(program)
      program.registrations.sort_by { |r| r.diver.name.to_s.downcase }
    end
  end
end
