# frozen_string_literal: true

module Staff
  module UsersHelper
    def staff_user_role_label(user)
      I18n.t("activerecord.enums.user.role.#{user.role}", default: user.role.to_s.humanize)
    end

    # No se puede eliminar (ni dejar sin titulares) al único usuario con rol titular.
    def staff_user_only_owner?(user)
      user.owner? && user.agency.users.where(role: :owner).count == 1
    end

    def staff_user_avatar_or_initials(user, size: :sm)
      px = ApplicationHelper::USER_AVATAR_PIXELS[size] || 40
      size_class = case size
      when :sm then "h-8 w-8 min-h-8 min-w-8 text-[10px] leading-none"
      when :md then "h-10 w-10 text-xs"
      else "h-8 w-8 text-[10px] leading-none"
      end

      if user.avatar.attached? && user.avatar.persisted?
        user_avatar_for(user, variant: size, extra_class: "shrink-0")
      else
        content_tag(:span,
                    staff_user_initials_for(user.name),
                    class: "inline-flex #{size_class} shrink-0 items-center justify-center rounded-full bg-profundo font-semibold text-espuma",
                    style: "width:#{px}px;height:#{px}px;min-width:#{px}px")
      end
    end

    def staff_user_initials_for(name)
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
  end
end
