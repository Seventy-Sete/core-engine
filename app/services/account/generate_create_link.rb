# frozen_string_literal: true

module Account
  class GenerateCreateLink < ApplicationService
    include Storage::Keys

    attr_reader :email

    def initialize(email)
      @email = email
    end

    def call
      redis.set redis_key, email
      redis.expire redis_key, redis_expiration

      NotifierUserMailer.with(email:).new_account(token).deliver_later
    end

    private

    def token
      @token ||= SecureRandom.hex(64)
    end

    def redis
      @redis ||= Redis.new
    end

    def redis_key
      @redis_key ||= format(CREATE_ACCOUNT_LINK, token:)
    end

    def redis_expiration
      @redis_expiration ||= 7.days.to_i
    end
  end
end
