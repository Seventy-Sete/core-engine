# frozen_string_literal: true

require 'test_helper'

module Api
  module V1
    class AuthControllerTest < ActionDispatch::IntegrationTest
      test 'should get join_with_email' do
        get api_v1_auth_join_with_email_url
        assert_response :success
      end

      test 'should get login_with_email' do
        get api_v1_auth_login_with_email_url
        assert_response :success
      end

      test 'should get login_with_token' do
        get api_v1_auth_login_with_token_url
        assert_response :success
      end

      test 'should get create_account' do
        get api_v1_auth_create_account_url
        assert_response :success
      end

      test 'should get reset_password' do
        get api_v1_auth_reset_password_url
        assert_response :success
      end
    end
  end
end
