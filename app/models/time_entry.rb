class TimeEntry
  include Mongoid::Document

  embedded_in :forecast

  field :entry_date, type: Date
  field :hours, type: Float
end
