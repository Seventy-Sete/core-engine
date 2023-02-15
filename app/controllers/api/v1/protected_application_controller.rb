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
        headers = if request.post?
                    request.params['headers']
                  else
                    request.headers
                  end
        {
          user_id: headers['X-User-Id'],
          token: headers['X-User-Token']
        }
      end
    end
  end
end
