# frozen_string_literal: true

module Nubank
  class NewAuthTo < ApplicationService
    include NubankSdk
    include Storage::Keys

    attr_reader :password, :user_bank_id

    def initialize(password, user_bank_id)
      @password = password
      @user_bank_id = user_bank_id
    end

    def call
      user_nubank.auth.authenticate_with_certificate password
      # TODO: fix nubank where it is not returning the refresh token

      save_bank_tokens(user_nubank.auth.access_token, user_nubank.auth.refresh_token, user_nubank.auth.refresh_before)
    end

    private

    def user_nubank
      @user_nubank ||= NubankSdk::Client.new cpf: user_bank.bcn
    end

    def user_bank
      @user_bank ||= UserBank.find(user_bank_id)
    end

    def save_bank_tokens(token, refresh_token, refresh_before)
      puts '*******************************************'
      puts refresh_before
      # TODO: add 'expires_at' to tokens

      data = {
        token:,
        refresh_token:
      }

      redis.hmset(redis_key, data)
      # redis.expireat(redis_key, refresh_before)
    end

    def redis
      @redis ||= Redis.new
    end

    def redis_key
      @redis_key = format(USER_BANK_DATA, user_bank_id: user_bank.id)
    end
  end
end
