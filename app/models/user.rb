class User < ApplicationRecord
  encrypts :email, deterministic: true, downcase: true
  encrypts :password, deterministic: true
end
