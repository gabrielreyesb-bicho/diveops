# frozen_string_literal: true

# payment_method values match the requirements doc (field "method": cash | transfer | stripe | other).
class Payment < ApplicationRecord
  enum :payment_method, {
    cash: 0,
    transfer: 1,
    stripe: 2,
    other: 3
  }, prefix: :pay, validate: true

  enum :status, {
    pending: 0,
    completed: 1,
    refunded: 2
  }, prefix: :payment, validate: true

  belongs_to :registration

  validates :amount, numericality: { greater_than: 0 }
end
