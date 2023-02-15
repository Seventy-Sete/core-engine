# frozen_string_literal: true

module Auth
  class CreateAccount < ApplicationService
    include AccountManager
    include Password

    attr_reader :email, :password, :token

    def initialize(token, email, password)
      @token = token
      @email = email
      @password = password
    end

    def call
      return { action: :weak_password, follow_up: :try_again } unless strong_password? password

      return create_new_user if redis.get(redis_key) == email

      {
        user: nil,
        fails: nil,
        action: :create_account_fail,
        follow_up: :join_with_email,
        and: :try_again
      }
    end

    private

    def create_new_user
      user = User.create(email:, password:)
      token = Auth::CreateAccessToken(user.id)
      redis.del redis_key
      {
        user: { email: user.email, id: user.id },
        fails: user_fails(user.id),
        action: :logged_in,
        follow_up: :be_happy,
        token:
      }
    end

    def redis
      @redis ||= Redis.new
    end

    def redis_key
      @redis_key ||= format(NEW_ACCOUNT_PASSWORD_LINK, token:)
    end
  end
end
