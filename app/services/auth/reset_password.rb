# frozen_string_literal: true

module Auth
  class ResetPassword < ApplicationService
    include AccountManager

    attr_reader :token, :user_id, :password

    def initialize(token, user_id, password)
      @token = token
      @user_id = user_id
      @password = password
    end

    def call
      return reset_password if redis.get(redis_key) == user_id
      return blocked_user if user_blocked?(user_id)

      {
        action: :reset_password_full_fail,
        follow_up: :stop_kidding_me
      }
    end

    private

    def blocked_user
      Auth::GenerateResetPasswordLink(user.id)
      {
        user: nil,
        fails: nil,
        action: :reset_password_fail,
        follow_up: :check_user_email,
        and: :try_again
      }
    end

    def reset_password
      user = User.find user_id
      user.password = password
      user.save
      clear_user_fails(user_id)
      Auth::CreateAccessToken(user.id)
      redis.del redis_key
      { user: { email: user.email, id: user.id }, fails: user_fails(user.id),
        action: :logged_in, follow_up: :be_caution, token: }
    end

    def redis
      @redis ||= Redis.new
    end

    def redis_key
      @redis_key ||= format(RESET_PASSWORD_LINK, token:)
    end
  end
end
