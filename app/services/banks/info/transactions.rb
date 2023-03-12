# frozen_string_literal: true

module Banks
  module Info
    class Transactions < ApplicationService
      attr_reader :user

      def initialize(params)
        @user = params[:user]
      end

      def call
        user_bank_list = user.user_banks

        user_bank_list.each_with_object({}) do |user_bank, hash|
          hash[user_bank.id] = user_bank.bank_transactions.each_with_object({}) do |transaction, hash|
            hash[transaction.id] = {
              transaction_id: transaction.transaction_id,
              user_bank_id: transaction.user_bank_id,
              title: transaction.title,
              amount: transaction.amount,
              due_date: transaction.due_date,
              tags: transaction.tags,
              purpose: transaction.purpose,
              created_at: transaction.created_at,
              updated_at: transaction.updated_at
            }
          end
        end
      end
    end
  end
end
