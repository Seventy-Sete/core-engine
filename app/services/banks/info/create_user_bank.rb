# frozen_string_literal: true

module Banks
  module Info
    class CreateUserBank < ApplicationService
      attr_reader :user, :bank_name, :amount

      def initialize(params)
        @user = params[:user]
        @bank_name = params[:bank_name]
        @amount = params[:amount]
      end

      def call
        UserBank.delete_all
        BankDetail.delete_all
        bank = user.user_banks.create(
          bank: :default,
          bank_name:,
          status: :active
        )
        UserBank.find(bank.id).bank_details.create(
          reference: Time.zone.now.strftime('%Y%m').to_i,
          balance: amount.to_f,
          incoming: 0,
          outgoing: 0
        )
      end
    end
  end
end
