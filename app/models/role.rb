class Role
  include Mongoid::Document

  belongs_to :organization
  field :organization_id, type: BSON::ObjectId

  belongs_to :user
  field :user_id, type: BSON::ObjectId

  belongs_to :project_role
  field :project_role_id, type: BSON::ObjectId

  field :name, type: String
  field :rate, type: Float
  field :cost, type: Float
end
