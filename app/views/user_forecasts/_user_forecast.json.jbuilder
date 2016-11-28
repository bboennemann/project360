json.extract! user_forecast, :total_hours, :total_amount, :total_cost
json.url user_forecast_url(user_forecast, format: :json)