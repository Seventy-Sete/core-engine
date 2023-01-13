require "test_helper"

class Api::V1::NubankControllerTest < ActionDispatch::IntegrationTest
  test "should get auth_validate" do
    get api_v1_nubank_auth_validate_url
    assert_response :success
  end

  test "should get auth_request_email_code" do
    get api_v1_nubank_auth_request_email_code_url
    assert_response :success
  end

  test "should get exchange_certificates" do
    get api_v1_nubank_exchange_certificates_url
    assert_response :success
  end

  test "should get new_auth_to" do
    get api_v1_nubank_new_auth_to_url
    assert_response :success
  end

  test "should get account_balance" do
    get api_v1_nubank_account_balance_url
    assert_response :success
  end

  test "should get credit_balances" do
    get api_v1_nubank_credit_balances_url
    assert_response :success
  end

  test "should get account_feed" do
    get api_v1_nubank_account_feed_url
    assert_response :success
  end

  test "should get credit_feed" do
    get api_v1_nubank_credit_feed_url
    assert_response :success
  end

  test "should get account_details" do
    get api_v1_nubank_account_details_url
    assert_response :success
  end

  test "should get credit_details" do
    get api_v1_nubank_credit_details_url
    assert_response :success
  end
end
