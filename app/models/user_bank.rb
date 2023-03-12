# frozen_string_literal: true

class UserBank < ApplicationRecord
  belongs_to :user
  has_many :bank_transactions
  has_many :bank_details
  has_many :user_bank_credits

  validates :bank, presence: true

  encrypts :bcn, deterministic: true
  encrypts :access_key, deterministic: true
end
