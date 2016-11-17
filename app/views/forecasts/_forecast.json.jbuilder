json.extract! forecast, :id, :name, :revision, :created_at, :updated_at
json.url forecast_url(forecast, format: :json)