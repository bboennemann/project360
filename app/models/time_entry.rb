class TimeEntry
  include Mongoid::Document

  embedded_in :forecast
  field :forecast_id, type: BSON::ObjectId

  field :entry_date, type: Date
  field :hours, type: Float
end
