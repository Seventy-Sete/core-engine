# frozen_string_literal: true

module Nubank
  class NewAuthTo < ApplicationService
    include NubankSdk

    attr_reader :user_id, :bcn

    def initialize(user_id, bcn)
      @user_id = user_id
      @bcn = bcn
    end

    def call
      user_bank = user.user_banks.create(bank: :nubank, bcn:, status: :pending_encryption)

      {
        user_bank_id: user_bank.id,
        follow_up: :request_email_code
      }
    end

    private

    def user
      @user ||= User.find(user_id)
    end
  end
end
