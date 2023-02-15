# frozen_string_literal: true

module Storage
  module Keys
    USER_AUTH_FAIL = 'user:%<user_id>s:auth:fails'
    AUTH_TOKEN = 'auth:token:%<token>s'
    NEW_ACCOUNT_PASSWORD_LINK = 'auth:new_account:password_link:%<token>s'
    RESET_PASSWORD_LINK = 'auth:reset_password:password_link:%<token>s'
    USER_BANK_DATA = 'user_bank:%<user_bank_id>s:data'
    USER_BANK_TOKENS = 'user_bank:%<user_bank_id>s:tokens'
  end
end
