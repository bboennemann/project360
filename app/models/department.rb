class Department
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :clients

  has_one :project_setting
  
  belongs_to :organization
  field :organization_id, type: BSON::ObjectId

  field :name, type: String
  
end
