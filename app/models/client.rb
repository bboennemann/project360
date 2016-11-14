class Client
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :department
  field :department_id, type: BSON::ObjectId

  belongs_to :organization
  field :organization_id, type: BSON::ObjectId

  field :name, type: String
end
