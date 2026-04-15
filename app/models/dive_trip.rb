# frozen_string_literal: true

class DiveTrip < ApplicationRecord
  include ProgramCapacity

  enum :status, {
    planning: 0,
    open: 1,
    full: 2,
    pending_confirmation: 3,
    confirmed: 4,
    cancelled: 5
  }, prefix: :program, validate: true

  belongs_to :agency
  has_many :photos, as: :attachable, dependent: :destroy
  has_many :registrations, as: :program, dependent: :destroy
  has_many :interests, as: :program, dependent: :destroy

  has_rich_text :description
  has_rich_text :requirements
  has_rich_text :itinerary

  validates :title, :destination, :departure_date, :return_date, presence: true
  validates :max_capacity, :min_capacity,
            numericality: { only_integer: true, greater_than: 0 }
  validates :base_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  validate :min_capacity_not_greater_than_max_capacity

  private

  def min_capacity_not_greater_than_max_capacity
    return if max_capacity.blank? || min_capacity.blank?

    errors.add(:min_capacity, "must be less than or equal to max capacity") if min_capacity > max_capacity
  end
end
