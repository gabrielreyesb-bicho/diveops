# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { owner: 0, staff: 1 }, validate: true

  belongs_to :agency, optional: true
  has_one_attached :avatar

  validates :name, presence: true
  validates :agency_id, presence: true, unless: :super_admin?
end
