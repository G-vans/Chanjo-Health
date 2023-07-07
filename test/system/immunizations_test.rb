require "application_system_test_case"

class ImmunizationsTest < ApplicationSystemTestCase
  setup do
    @immunization = immunizations(:one)
  end

  test "visiting the index" do
    visit immunizations_url
    assert_selector "h1", text: "Immunizations"
  end

  test "should create immunization" do
    visit immunizations_url
    click_on "New immunization"

    fill_in "Child", with: @immunization.child_id
    fill_in "Date", with: @immunization.date
    fill_in "Medic", with: @immunization.medic_id
    fill_in "Vax name", with: @immunization.vax_name
    click_on "Create Immunization"

    assert_text "Immunization was successfully created"
    click_on "Back"
  end

  test "should update Immunization" do
    visit immunization_url(@immunization)
    click_on "Edit this immunization", match: :first

    fill_in "Child", with: @immunization.child_id
    fill_in "Date", with: @immunization.date
    fill_in "Medic", with: @immunization.medic_id
    fill_in "Vax name", with: @immunization.vax_name
    click_on "Update Immunization"

    assert_text "Immunization was successfully updated"
    click_on "Back"
  end

  test "should destroy Immunization" do
    visit immunization_url(@immunization)
    click_on "Destroy this immunization", match: :first

    assert_text "Immunization was successfully destroyed"
  end
end
