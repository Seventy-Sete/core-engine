class UserBank < ApplicationRecord
  belongs_to :user
  has_many :bank_transactions

  encrypts :cpf, deterministic: true
  encrypts :access_key, deterministic: true
end
