# frozen_string_literal: true

module Api
  module V1
    class UserBankController < ProtectedApplicationController
      def list
        render json: Banks::Info::ListAll.call(user: current_user)
      end

      def transactions
        render json: Banks::Info::Transactions.call(user: current_user)
      end

      def new
        body = JSON.parse(request.body.read)
        bank_name = body['bank_name']
        amount = body['amount']

        render json: Banks::Info::CreateUserBank.call(
          user: current_user,
          bank_name:,
          amount:
        )
      end

      def account_balance; end

      def credit_balances; end

      def account_feed; end

      def credit_feed; end

      def account_details; end

      def credit_details; end

      def delete
        user_bank_id = params[:id]

        render json: UserBank.find(user_bank_id).destroy
      end
    end
  end
end
