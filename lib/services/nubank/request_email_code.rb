# frozen_string_literal: true

module Nubank
  class RequestEmailCode < ApplicationService
    include NubankSdk
    include Storage::Keys

    attr_reader :password, :bank_id

    def initialize(bank_id, password)
      @password = password
      @bank_id = bank_id
    end

    def call
      return { error: 'without password' } unless password

      data = user_nubank.auth.request_email_code password

      encrypted_code = data[:device_authorization_encrypted_code]
      p_key = user_nubank.auth.p_key.to_pem

      save_codes(encrypted_code, p_key)
      user_bank.update(status: :pending_email_code)

      { follow_up: :exchange_certificates, check_user_email: data[:sent_to] }
    end

    private

    def user_nubank
      @user_nubank ||= NubankSdk::Client.new cpf: user_bank.bcn
    end

    def user_bank
      @user_bank ||= UserBank.find(bank_id)
    end

    def save_codes(encrypted_code, p_key)
      data = {
        encrypted_code:,
        p_key:
      }

      redis.hmset(redis_key, data.deep_stringify_keys)
    end

    def redis
      @redis ||= Redis.new
    end

    def redis_key
      @redis_key = format(USER_BANK_DATA, user_bank_id: user_bank.id)
    end
  end
end
