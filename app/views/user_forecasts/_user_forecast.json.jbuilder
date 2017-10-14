json.extract! user_forecast, :total_hours
json.day_total_hours @forecast.day_total_hours @entry_date
json.day_total_amount number_to_currency @forecast.day_total_amount @entry_date
json.total_cost number_to_currency user_forecast.total_cost
json.total_result number_to_currency user_forecast.total_result
json.total_amount number_to_currency user_forecast.total_amount
json.forecast_total_amount  number_to_currency@user_forecast.forecast.total_amount
json.forecast_total_hours @user_forecast.forecast.total_hours.round(2)
json.url user_forecast_url(user_forecast, format: :json)