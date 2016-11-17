class TimeEntry
  include Mongoid::Document
  field :entry_date, type: Date
  field :hours, type: Float
end
