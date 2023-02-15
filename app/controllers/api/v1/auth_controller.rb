# frozen_string_literal: true

module Api
  module V1
    class AuthController < ApplicationController
      def join_with_email
        email = params[:email]

        render json: Auth::JoinWithEmail.call(email)
      end

      def login_with_email
        email = params[:email]
        password = request.headers['password']

        render json: Auth::LoginWithEmail.call(email, password)
      end

      def login_with_token
        token = params[:token]
        user_id = params[:user_id]

        render json: Auth::LoginWithToken.call(token, user_id)
      end

      def create_account
        token = params[:token]
        email = params[:email]
        password = request.headers['password']

        render json: Auth::CreateAccount.call(token, email, password)
      end

      def reset_password
        token = params[:token]
        user_id = params[:user_id]
        password = request.headers['password']

        render json: Auth::ResetPassword.call(token, user_id, password)
      end
    end
  end
end
