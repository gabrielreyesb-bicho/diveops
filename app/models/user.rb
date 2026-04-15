# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { owner: 0, staff: 1 }, validate: true

  belongs_to :agency

  validates :name, presence: true
end
