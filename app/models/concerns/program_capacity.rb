# frozen_string_literal: true

# Capacity rules for DiveTrip and Course: pending + confirmed occupy signup slots;
# program status +full+ / +open+ follows confirmed count vs max_capacity.
module ProgramCapacity
  extend ActiveSupport::Concern

  def registration_slots_used
    registrations.occupying_capacity.count
  end

  def registration_slots_available?
    max_capacity.present? && registration_slots_used < max_capacity
  end

  def confirmed_registrations_count
    registrations.registration_confirmed.count
  end

  def sync_program_status_from_registrations!
    return if program_planning? || program_cancelled?
    return if max_capacity.blank?

    confirmed_n = confirmed_registrations_count

    if program_full?
      program_open! if confirmed_n < max_capacity
    elsif (program_open? || program_pending_confirmation?) && confirmed_n >= max_capacity
      program_full!
    end
  end
end
