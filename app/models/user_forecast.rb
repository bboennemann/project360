class UserForecast
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :forecast
  field :forecast_id, type: BSON::ObjectId

  belongs_to :project_role
  field :project_role_id, type: BSON::ObjectId

  belongs_to :user
  field :user_id, type: BSON::ObjectId

  embeds_many :time_entries
  accepts_nested_attributes_for :time_entries
  
  field :published, type: Mongoid::Boolean
end
