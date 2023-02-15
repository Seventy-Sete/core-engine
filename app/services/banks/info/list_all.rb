# frozen_string_literal: true

module Banks
  module Info
    class ListAll < ApplicationService
      attr_reader :user

      def initialize(params)
        @user = params[:user]
      end

      def call
        user_bank_list = user.user_banks

        user_bank_list.each_with_object({}) do |user_bank, hash|
          hash[user_bank.id] = {
            bank: user_bank.bank,
            bank_name: user_bank.bank_name,
            bcn: user_bank.bcn,
            status: user_bank.status,
            created_at: user_bank.created_at,
            updated_at: user_bank.updated_at,
            details: {
              current: user_bank.bank_details.current.first
            }
          }
        end
      end
    end
  end
end
