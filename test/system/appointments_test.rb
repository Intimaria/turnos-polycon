require "application_system_test_case"

class AppointmentsTest < ApplicationSystemTestCase
  setup do
    @appointment = appointments(:one)
  end

  test "visiting the index" do
    visit appointments_url
    assert_selector "h1", text: "Appointments"
  end

  test "creating a Appointment" do
    visit appointments_url
    click_on "New Appointment"

    check "Active" if @appointment.active
    fill_in "Name", with: @appointment.name
    fill_in "Notes", with: @appointment.notes
    fill_in "Phone", with: @appointment.phone
    fill_in "Professional", with: @appointment.professional
    fill_in "Surname", with: @appointment.surname
    click_on "Create Appointment"

    assert_text "Appointment was successfully created"
    click_on "Back"
  end

  test "updating a Appointment" do
    visit appointments_url
    click_on "Edit", match: :first

    check "Active" if @appointment.active
    fill_in "Name", with: @appointment.name
    fill_in "Notes", with: @appointment.notes
    fill_in "Phone", with: @appointment.phone
    fill_in "Professional", with: @appointment.professional
    fill_in "Surname", with: @appointment.surname
    click_on "Update Appointment"

    assert_text "Appointment was successfully updated"
    click_on "Back"
  end

  test "destroying a Appointment" do
    visit appointments_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Appointment was successfully destroyed"
  end
end
