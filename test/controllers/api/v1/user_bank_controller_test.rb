require "test_helper"

class Api::V1::UserBankControllerTest < ActionDispatch::IntegrationTest
  test "should get account_balance" do
    get api_v1_user_bank_account_balance_url
    assert_response :success
  end

  test "should get credit_balances" do
    get api_v1_user_bank_credit_balances_url
    assert_response :success
  end

  test "should get account_feed" do
    get api_v1_user_bank_account_feed_url
    assert_response :success
  end

  test "should get credit_feed" do
    get api_v1_user_bank_credit_feed_url
    assert_response :success
  end

  test "should get account_details" do
    get api_v1_user_bank_account_details_url
    assert_response :success
  end

  test "should get credit_details" do
    get api_v1_user_bank_credit_details_url
    assert_response :success
  end
end
