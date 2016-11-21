require 'test_helper'

class UserForecastsControllerTest < ActionController::TestCase
  setup do
    @user_forecast = user_forecasts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_forecasts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_forecast" do
    assert_difference('UserForecast.count') do
      post :create, user_forecast: { published: @user_forecast.published, timeentry: @user_forecast.timeentry }
    end

    assert_redirected_to user_forecast_path(assigns(:user_forecast))
  end

  test "should show user_forecast" do
    get :show, id: @user_forecast
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_forecast
    assert_response :success
  end

  test "should update user_forecast" do
    patch :update, id: @user_forecast, user_forecast: { published: @user_forecast.published, timeentry: @user_forecast.timeentry }
    assert_redirected_to user_forecast_path(assigns(:user_forecast))
  end

  test "should destroy user_forecast" do
    assert_difference('UserForecast.count', -1) do
      delete :destroy, id: @user_forecast
    end

    assert_redirected_to user_forecasts_path
  end
end
