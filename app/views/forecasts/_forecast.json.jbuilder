json.extract! forecast, :id, :name, :published
json.url forecast_url(forecast, format: :json)