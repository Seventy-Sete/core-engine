class User < ApplicationRecord
  has_many :user_banks

  encrypts :email, deterministic: true, downcase: true
  encrypts :password, deterministic: true

  validates :email, presence: true, uniqueness: true
end
