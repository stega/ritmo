require "test_helper"

class ResearchersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @researcher = researchers(:one)
  end

  test "should get index" do
    get researchers_url
    assert_response :success
  end

  test "should get new" do
    get new_researcher_url
    assert_response :success
  end

  test "should create researcher" do
    assert_difference('Researcher.count') do
      post researchers_url, params: { researcher: { name: @researcher.name } }
    end

    assert_redirected_to researcher_url(Researcher.last)
  end

  test "should show researcher" do
    get researcher_url(@researcher)
    assert_response :success
  end

  test "should get edit" do
    get edit_researcher_url(@researcher)
    assert_response :success
  end

  test "should update researcher" do
    patch researcher_url(@researcher), params: { researcher: { name: @researcher.name } }
    assert_redirected_to researcher_url(@researcher)
  end

  test "should destroy researcher" do
    assert_difference('Researcher.count', -1) do
      delete researcher_url(@researcher)
    end

    assert_redirected_to researchers_url
  end
end
