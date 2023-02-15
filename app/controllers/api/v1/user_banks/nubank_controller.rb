# frozen_string_literal: true

module Api
  module V1
    module UserBanks
      class NubankController < ApplicationController
        def new_auth_to
          request_entrypoint(:nubank_module)

          bcn = params[:bcn]
          render json: Banks::Nubank.new(@user_id).new_auth_to(bcn), status: :ok
        rescue StandardError => e
          render json: { error: e.message }, status: :bad_request
        end

        def request_email_code
          request_entrypoint(:nubank_module)

          user_bank_id = params[:id]
          password = request.headers['X-User-Password']

          render json: Banks::Nubank.new(@user_id, user_bank_id).request_email_code(password), status: :ok
        rescue StandardError => e
          render json: { error: e.message }, status: :bad_request
        end

        def exchange_certificates
          request_entrypoint(:nubank_module)

          user_bank_id = params[:id]
          email_code = params[:email_code]
          password = (request.headers || {})['X-User-Password'] || (params[:headers] || {})['X-User-Password']

          render json: Banks::Nubank.new(@user_id, user_bank_id).exchange_certificates(email_code, password),
                 status: :ok
        rescue StandardError => e
          render json: { error: e.message }, status: :bad_request
        end

        private

        def request_entrypoint(_feature)
          @user_id = (request.headers || {})['X-User-Id'] || (params[:headers] || {})['X-User-Id']
          @token = (request.headers || {})['X-User-Token'] || (params[:headers] || {})['X-User-Token']

          # access = Features::Control.new(@user_id, @token).access?(feature)
          # raise 'Access denied' unless access
        end
      end
    end
  end
end
