# frozen_string_literal: true

class Registration < ApplicationRecord
  enum :status, {
    pending: 0,
    confirmed: 1,
    waitlisted: 2,
    cancelled: 3
  }, prefix: :registration, validate: true

  belongs_to :program, polymorphic: true
  belongs_to :diver
  has_many :payments, dependent: :destroy

  scope :occupying_capacity, -> { where(status: %i[pending confirmed]) }

  validate :program_must_be_dive_trip_or_course

  private

  def program_must_be_dive_trip_or_course
    return if program.is_a?(DiveTrip) || program.is_a?(Course)

    errors.add(:program, :invalid)
  end
end
