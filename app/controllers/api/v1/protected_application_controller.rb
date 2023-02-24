# frozen_string_literal: true

module Api
  module V1
    class ProtectedApplicationController < ApplicationController
      attr_reader :current_user

      before_action :authenticate_request

      private

      def authenticate_request
        @current_user = Auth::AuthorizeApiRequest.call(auth_parameters)
        render json: { error: 'Not Authorized' }, status: 401 unless @current_user
      end

      def auth_parameters
        {
          user_id: request.headers['X-User-Id'],
          token: request.headers['X-User-Token']
        }
      end
    end
  end
end
