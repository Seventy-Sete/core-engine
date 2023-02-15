# frozen_string_literal: true

class BankTransaction < ApplicationRecord
  enum purpose: { scheduled: 0, transfer: 1, payment: 2, deposit: 3, withdrawal: 4, tax: 5, bonus: 6, other: 7 }

  belongs_to :user_bank

  validates :purpose, inclusion: { in: BankTransaction.purposes.keys }
  validates :amount, numericality: { greater_than: 0 }

  scope :scheduled, -> { where(purpose: :scheduled) }
  scope :credit, -> { where(purpose: %i[deposit bonus]) }
  scope :debit, -> { where(purpose: %i[withdrawal tax]) }
end
