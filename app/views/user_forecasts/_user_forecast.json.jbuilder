json.extract! user_forecast, :id,  :published, :created_at, :updated_at
json.url user_forecast_url(user_forecast, format: :json)