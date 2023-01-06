require "test_helper"

class Api::V1::NubankControllerTest < ActionDispatch::IntegrationTest
  test "should get auth" do
    get api_v1_nubank_auth_url
    assert_response :success
  end

  test "should get account/balance" do
    get api_v1_nubank_account/balance_url
    assert_response :success
  end

  test "should get account/feed" do
    get api_v1_nubank_account/feed_url
    assert_response :success
  end
end
