# frozen_string_literal: true

class Interest < ApplicationRecord
  belongs_to :program, polymorphic: true
  belongs_to :diver

  validate :program_must_be_dive_trip_or_course

  private

  def program_must_be_dive_trip_or_course
    return if program.is_a?(DiveTrip) || program.is_a?(Course)

    errors.add(:program, :invalid)
  end
end
