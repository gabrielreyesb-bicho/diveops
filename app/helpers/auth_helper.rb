# frozen_string_literal: true

module AuthHelper
  def auth_input_class
    "mt-1.5 w-full rounded-xl border border-arrecife/80 bg-white px-3 py-2.5 text-sm text-abismo shadow-sm placeholder:text-slate-400 transition focus:border-oceano focus:outline-none focus:ring-2 focus:ring-oceano/25"
  end

  def auth_select_class
    "#{auth_input_class} cursor-pointer"
  end

  def auth_label_class
    "block text-sm font-medium text-slate-700"
  end

  def auth_secondary_link_class
    "font-medium text-caribe underline decoration-arrecife underline-offset-2 transition hover:text-oceano"
  end

  def auth_card_title_class
    "text-xl font-semibold tracking-tight text-abismo"
  end

  def auth_muted_class
    "text-sm text-slate-600"
  end
end
