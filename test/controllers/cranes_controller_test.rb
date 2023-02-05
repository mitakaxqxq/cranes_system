require "test_helper"

class CranesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @crane = cranes(:one)
  end

  test "should get index" do
    get cranes_url
    assert_response :success
  end

  test "should get new" do
    get new_crane_url
    assert_response :success
  end

  test "should create crane" do
    assert_difference("Crane.count") do
      post cranes_url, params: { crane: { registration_date: @crane.registration_date, serial_number: @crane.serial_number, status: @crane.status } }
    end

    assert_redirected_to crane_url(Crane.last)
  end

  test "should show crane" do
    get crane_url(@crane)
    assert_response :success
  end

  test "should get edit" do
    get edit_crane_url(@crane)
    assert_response :success
  end

  test "should update crane" do
    patch crane_url(@crane), params: { crane: { registration_date: @crane.registration_date, serial_number: @crane.serial_number, status: @crane.status } }
    assert_redirected_to crane_url(@crane)
  end

  test "should destroy crane" do
    assert_difference("Crane.count", -1) do
      delete crane_url(@crane)
    end

    assert_redirected_to cranes_url
  end
end
