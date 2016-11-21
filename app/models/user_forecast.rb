class UserForecast
  include Mongoid::Document

  belongs_to :forecast
  field :forecast_id, type: BSON::ObjectId

  belongs_to :project_role
  field :project_role_id, type: BSON::ObjectId

  embeds_many :time_entries

  field :timeentry, type: String
  field :published, type: Mongoid::Boolean
end
