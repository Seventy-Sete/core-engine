# frozen_string_literal: true

module Auth
  class LoginWithEmail < ApplicationService
    include AccountManager

    attr_reader :email, :password

    def initialize(email, password)
      @email = email
      @password = password
    end

    def call
      return :no_account unless user
      return :blocked_account if user_blocked? user.id
      return grant_access if user.password == password

      user_fail(user.id)

      return block_user if user_blocked?(user.id)

      {
        user: { email: user.email },
        fails: user_fails(user.id),
        action: :wrong_password,
        follow_up: :try_again
      }
    end

    private

    def block_user
      Auth::GenerateResetPasswordLink.call(user.id)
      {
        user: { email: user.email },
        fails: user_fails(user.id),
        action: :reset_password,
        follow_up: :check_user_email
      }
    end

    def user
      @user ||= User.find_by(email:)
    end

    def grant_access
      token = Auth::CreateAccessToken.call(user.id)

      clear_user_fails(user.id)
      {
        user: { email: user.email, id: user.id },
        action: :logged_in,
        follow_up: :be_creative,
        token:
      }
    end
  end
end
