class UserBankCredit < ApplicationRecord
  belongs_to :user_bank

  has_many :user_bank_credit_cards
end
