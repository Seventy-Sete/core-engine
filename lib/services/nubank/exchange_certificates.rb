# frozen_string_literal: true

module Nubank
  class ExchangeCertificates < ApplicationService
    include NubankSdk
    include Storage::Keys

    attr_reader :user_bank_id, :email_code, :password

    def initialize(user_bank_id, email_code, password)
      @user_bank_id = user_bank_id
      @email_code = email_code
      @password = password
    end

    def call
      recovered_codes = recovery_codes

      user_nubank.auth.p_key = recovered_codes[:p_key]

      user_nubank.auth.exchange_certs(email_code, password, recovered_codes[:encrypted_code])
      # Nubank::NewToken.call(password)
      user_bank.update(
        status: :active,
        access_key: password
      )

      {
        follow_up: :account_details,
        action: :certification_success
      }
    end

    private

    def user_nubank
      @user_nubank ||= NubankSdk::User.new cpf: user_bank.bcn
    end

    def recovery_codes
      data = redis.hgetall(redis_key)
      {
        encrypted_code: data['encrypted_code'],
        p_key: OpenSSL::PKey::RSA.new(data['p_key'])
      }
    end

    def redis
      @redis ||= Redis.new
    end

    def redis_key
      @redis_key ||= format(USER_BANK_DATA, user_bank_id: user_bank.id)
    end

    def user_bank
      @user_bank ||= UserBank.find(user_bank_id)
    end
  end
end
