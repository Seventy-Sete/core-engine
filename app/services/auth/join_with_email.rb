# frozen_string_literal: true

module Auth
  class JoinWithEmail < ApplicationService
    include AccountManager

    attr_reader :email

    def initialize(email)
      @email = email
    end

    def call
      return new_account if user.nil?
      return blocked_account if user_blocked? user.id

      {
        user: { email: user.email },
        fails: user_fails(user.id),
        follow_up: :login_with_email,
        action: :login
      }
    end

    private

    def blocked_account
      {
        user: { email: user.email },
        fails: user_fails(user.id),
        action: :reset_password,
        follow_up: :check_user_email
      }
    end

    def new_account
      Account::GenerateCreateLink.call(email)

      {
        follow_up: :check_user_email,
        action: :preparation_to_create_account
      }
    end

    def user
      @user ||= User.find_by(email:)
    end
  end
end
