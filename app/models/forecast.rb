class Forecast
  include Mongoid::Document

  belongs_to :project
  field :project_id, type: BSON::ObjectId


  field :name, type: String
  field :revision, type: Integer
end
