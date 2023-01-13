class UserBank < ApplicationRecord
  belongs_to :user

  encrypts :cpf, deterministic: true
  encrypts :access_key, deterministic: true
end
