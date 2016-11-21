class Forecast
  include Mongoid::Document

  belongs_to :project
  field :project_id, type: BSON::ObjectId

  has_many :user_forecasts

  field :name, type: String
  field :revision, type: Integer
  field :published, type: Mongoid::Boolean
end
