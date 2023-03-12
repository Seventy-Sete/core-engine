# frozen_string_literal: true

class BankDetail < ApplicationRecord
  belongs_to :user_bank

  # validates :balance, numericality: { greater_than: 0 }
  # validates :incoming, numericality: { greater_than: 0 }
  # validates :outgoing, numericality: { greater_than: 0 }
  # validates :reference, numericality: { greater_than: 0 }, presence: true, length: { is: 6 }, uniqueness: {
  #   scope: :user_bank_id,
  #   message: 'Bank detail already exists for this month'
  # }

  scope :current, -> { where(reference: Time.zone.now.strftime('%Y%m').to_i) }
end
