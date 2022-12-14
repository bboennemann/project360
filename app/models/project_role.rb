class ProjectRole
  include Mongoid::Document

  belongs_to :user
  field :user_id, type: BSON::ObjectId

  belongs_to :project
  field :project_id, type: BSON::ObjectId

  belongs_to :role
  field :role_id, type: BSON::ObjectId

  has_many :user_forecasts

  field :rate, type: Float
  field :cost, type: Float

end
