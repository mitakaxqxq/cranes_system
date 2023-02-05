require "application_system_test_case"

class CranesTest < ApplicationSystemTestCase
  setup do
    @crane = cranes(:one)
  end

  test "visiting the index" do
    visit cranes_url
    assert_selector "h1", text: "Cranes"
  end

  test "should create crane" do
    visit cranes_url
    click_on "New crane"

    fill_in "Registration date", with: @crane.registration_date
    fill_in "Serial number", with: @crane.serial_number
    fill_in "Status", with: @crane.status
    click_on "Create Crane"

    assert_text "Crane was successfully created"
    click_on "Back"
  end

  test "should update Crane" do
    visit crane_url(@crane)
    click_on "Edit this crane", match: :first

    fill_in "Registration date", with: @crane.registration_date
    fill_in "Serial number", with: @crane.serial_number
    fill_in "Status", with: @crane.status
    click_on "Update Crane"

    assert_text "Crane was successfully updated"
    click_on "Back"
  end

  test "should destroy Crane" do
    visit crane_url(@crane)
    click_on "Destroy this crane", match: :first

    assert_text "Crane was successfully destroyed"
  end
end
