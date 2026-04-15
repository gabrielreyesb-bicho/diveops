# frozen_string_literal: true

class Course < ApplicationRecord
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

  validates :title, :start_date, :end_date, presence: true
  validates :max_capacity, :min_capacity,
            numericality: { only_integer: true, greater_than: 0 }
  validates :base_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  validate :min_capacity_not_greater_than_max_capacity
  validate :end_date_after_start_date

  private

  def min_capacity_not_greater_than_max_capacity
    return if max_capacity.blank? || min_capacity.blank?

    errors.add(:min_capacity, "must be less than or equal to max capacity") if min_capacity > max_capacity
  end

  def end_date_after_start_date
    return if start_date.blank? || end_date.blank?

    errors.add(:end_date, "must be on or after start date") if end_date < start_date
  end
end
