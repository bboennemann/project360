class Role
  include Mongoid::Document

  belongs_to :organization
  field :organization_id, type: BSON::ObjectId

  belongs_to :user
  field :user_id, type: BSON::ObjectId

  has_many :project_roles

  field :name, type: String
  field :rate, type: Float
  field :cost, type: Float
end
