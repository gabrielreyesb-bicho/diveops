# frozen_string_literal: true

class Photo < ApplicationRecord
  belongs_to :attachable, polymorphic: true

  has_one_attached :image

  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validate :attachable_must_be_dive_trip_or_course

  private

  def attachable_must_be_dive_trip_or_course
    return if attachable.is_a?(DiveTrip) || attachable.is_a?(Course)

    errors.add(:attachable, :invalid)
  end
end
