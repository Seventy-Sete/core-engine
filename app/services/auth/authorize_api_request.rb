# frozen_string_literal: true

module Auth
  class AuthorizeApiRequest < ApplicationService
    attr_reader :user_id, :token

    def initialize(params)
      @user_id = params[:user_id]
      @token = params[:token]
    end

    def call
      access = Auth::LoginWithToken.call(token, user_id)
      return false unless access == :valid_token

      user = User.find(user_id)
    end
  end
end
