# frozen_string_literal: true

module Auth
  class CreateAccessToken < ApplicationService
    include Storage::Keys

    attr_reader :user_id

    def initialize(user_id)
      @user_id = user_id
    end

    def call
      redis.set redis_key, user_id
      redis.expire redis_key, redis_expiration

      token
    end

    private

    def token
      @token ||= SecureRandom.hex(10)
    end

    def redis
      @redis ||= Redis.new
    end

    def redis_key
      @redis_key ||= format(AUTH_TOKEN, token:)
    end

    def redis_expiration
      @redis_expiration ||= 7.hours.to_i
    end
  end
end
