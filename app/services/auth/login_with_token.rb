# frozen_string_literal: true

module Auth
  class LoginWithToken < ApplicationService
    include Storage::Keys
    include AccountManager

    attr_reader :token, :user_id

    def initialize(token, user_id)
      @token = token
      @user_id = user_id
    end

    def call
      return :valid_token if redis.get(redis_key) == user_id && !user_id.nil?

      :token_fail
    end

    private

    def redis
      @redis ||= Redis.new
    end

    def redis_key
      @redis_key ||= format(AUTH_TOKEN, token:)
    end
  end
end
