module Storage
  module Keys
    def self.user_auth_fail(user_id)
      "user:#{user_id}:auth:fails"
    end
  
    def self.auth_token(token)
      "auth:token:#{token}"
    end
  
    def self.new_account_password_link(token)
      "auth:new_account:password_link:#{token}"
    end
  
    def self.reset_password_link(token)
      "auth:reset_password:password_link:#{token}"
    end

    def self.user_bank_data(user_bank_id)
      "user_bank:#{user_bank_id}:data"
    end

    def self.user_bank_tokens(user_bank_id)
      "user_bank:#{user_bank_id}:tokens"
    end
  end
end
