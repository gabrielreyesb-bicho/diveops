# frozen_string_literal: true

module Staff
  module RegistrationsHelper
    # Badges para panel staff (paleta DiveOps; distinto del catálogo).
    def staff_registration_status_badge_class(status)
      case status.to_s
      when "pending"
        "border border-arrecife bg-arrecife/40 text-abismo"
      when "confirmed"
        "border border-oceano bg-oceano text-espuma"
      when "waitlisted"
        "border border-coral/50 bg-coral/15 text-coral"
      when "cancelled"
        "border border-coral/40 bg-coral/10 text-profundo"
      else
        "border border-arrecife/50 bg-espuma text-abismo"
      end
    end

    def staff_registration_status_label(registration)
      case registration.status.to_s
      when "pending"
        "Pendiente"
      when "confirmed"
        "Confirmado"
      when "waitlisted"
        "En espera"
      when "cancelled"
        "Cancelado"
      else
        registration_status_text(registration)
      end
    end

    def diver_initials_for(name)
      return "?" if name.blank?

      parts = name.strip.split(/\s+/)
      letters =
        if parts.size >= 2
          "#{parts[0][0]}#{parts[1][0]}"
        else
          name.strip[0, 2]
        end
      letters.upcase
    end

    def staff_diver_avatar_or_initials(diver, size: :sm)
      px = ApplicationHelper::DIVER_AVATAR_PIXELS[size] || 40
      size_class = case size
      when :sm then "h-8 w-8 min-h-8 min-w-8 text-[10px] leading-none"
      when :md then "h-10 w-10 text-xs"
      else "h-8 w-8 text-[10px] leading-none"
      end

      if diver.avatar.attached? && diver.avatar.persisted?
        diver_avatar_for(diver, variant: size, extra_class: "shrink-0")
      else
        content_tag(:span,
                    diver_initials_for(diver.name),
                    class: "inline-flex #{size_class} shrink-0 items-center justify-center rounded-full bg-profundo font-semibold text-espuma",
                    style: "width:#{px}px;height:#{px}px;min-width:#{px}px")
      end
    end

    def staff_registration_counts_phrase(registrations)
      list = registrations.to_a
      return "" if list.empty?

      counts = list.group_by { |r| r.status.to_s }.transform_values(&:size)
      parts = []

      %w[confirmed pending waitlisted cancelled].each do |st|
        n = counts[st].to_i
        next if n.zero?

        parts << case st
        when "confirmed"
                   "#{n} #{n == 1 ? 'confirmado' : 'confirmados'}"
        when "pending"
                   "#{n} #{n == 1 ? 'pendiente' : 'pendientes'}"
        when "waitlisted"
                   "#{n} en espera"
        when "cancelled"
                   "#{n} #{n == 1 ? 'cancelado' : 'cancelados'}"
        end
      end

      parts.join(" · ")
    end

    # Misma altura y ancho mínimo que “Ver viaje” / secundarios del panel; waitlist en variante océano outline.
    STAFF_REG_BTN_ROW = "min-h-10 min-w-[11rem] cursor-pointer justify-center rounded-lg border-2 px-4 py-2 text-center text-sm font-medium shadow-sm transition"

    def staff_registration_btn_confirm_class
      "inline-flex items-center #{STAFF_REG_BTN_ROW} border-oceano bg-oceano text-espuma hover:border-profundo hover:bg-profundo"
    end

    def staff_registration_btn_waitlist_class
      "inline-flex items-center #{STAFF_REG_BTN_ROW} border-oceano bg-white text-oceano hover:bg-espuma hover:text-profundo"
    end

    def staff_registration_cancel_summary_class
      "inline-flex list-none items-center #{STAFF_REG_BTN_ROW} border-coral/55 bg-white text-coral hover:bg-coral/10 hover:text-coral-hover [&::-webkit-details-marker]:hidden"
    end
  end
end
