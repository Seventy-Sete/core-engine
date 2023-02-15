# frozen_string_literal: true

module Auth
  class GenerateResetPasswordLink < ApplicationService
    include Storage::Keys
    include AccountManager

    attr_reader :user_id

    def initialize(user_id)
      @user_id = user_id
    end

    def call
      redis.set redis_key, user_id
      redis.expire redis_key, redis_expiration

      NotifierUserMailer.with(email:).reset_password(user.id, token).deliver_later
    end

    private

    def redis
      @redis ||= Redis.new
    end

    def redis_key
      @redis_key ||= format(RESET_PASSWORD, token:)
    end

    def token
      @token ||= SecureRandom.hex(64)
    end

    def redis_expiration
      @redis_expiration ||= 7.days.to_i
    end
  end
end
