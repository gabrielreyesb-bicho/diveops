# frozen_string_literal: true

class Agency < ApplicationRecord
  has_many :users, dependent: :restrict_with_error
  has_many :dive_trips, dependent: :destroy
  has_many :courses, dependent: :destroy

  has_one_attached :logo

  validates :name, :slug, :contact_email, presence: true
  validates :slug, uniqueness: true
end
