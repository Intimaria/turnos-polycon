require "application_system_test_case"

class ProfessionalsTest < ApplicationSystemTestCase
  setup do
    @professional = professionals(:one)
  end

  test "visiting the index" do
    visit professionals_url
    assert_selector "h1", text: "Professionals"
  end

  test "creating a Professional" do
    visit professionals_url
    click_on "New Professional"

    check "Active" if @professional.active
    fill_in "Name", with: @professional.name
    fill_in "Surname", with: @professional.surname
    click_on "Create Professional"

    assert_text "Professional was successfully created"
    click_on "Back"
  end

  test "updating a Professional" do
    visit professionals_url
    click_on "Edit", match: :first

    check "Active" if @professional.active
    fill_in "Name", with: @professional.name
    fill_in "Surname", with: @professional.surname
    click_on "Update Professional"

    assert_text "Professional was successfully updated"
    click_on "Back"
  end

  test "destroying a Professional" do
    visit professionals_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Professional was successfully destroyed"
  end
end
