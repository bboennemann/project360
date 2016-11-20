class Forecast
  include Mongoid::Document

  belongs_to :project
  field :project_id, type: BSON::ObjectId

  belongs_to :user
  field :user_id, type: BSON::ObjectId

  embeds_many :time_entries

  field :name, type: String
  field :revision, type: Integer
end
