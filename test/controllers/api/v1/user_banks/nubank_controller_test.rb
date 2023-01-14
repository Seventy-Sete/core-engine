require "test_helper"

class Api::V1::UserBanks::NubankControllerTest < ActionDispatch::IntegrationTest
  test "should get new_auth_to" do
    get api_v1_banks_nubank_new_auth_to_url
    assert_response :success
  end

  test "should get request_email_code" do
    get api_v1_banks_nubank_request_email_code_url
    assert_response :success
  end

  test "should get exchange_certificates" do
    get api_v1_banks_nubank_exchange_certificates_url
    assert_response :success
  end
end
