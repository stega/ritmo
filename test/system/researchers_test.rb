require "application_system_test_case"

class ResearchersTest < ApplicationSystemTestCase
  setup do
    @researcher = researchers(:one)
  end

  test "visiting the index" do
    visit researchers_url
    assert_selector "h1", text: "Researchers"
  end

  test "creating a Researcher" do
    visit researchers_url
    click_on "New Researcher"

    fill_in "Name", with: @researcher.name
    click_on "Create Researcher"

    assert_text "Researcher was successfully created"
    click_on "Back"
  end

  test "updating a Researcher" do
    visit researchers_url
    click_on "Edit", match: :first

    fill_in "Name", with: @researcher.name
    click_on "Update Researcher"

    assert_text "Researcher was successfully updated"
    click_on "Back"
  end

  test "destroying a Researcher" do
    visit researchers_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Researcher was successfully destroyed"
  end
end
