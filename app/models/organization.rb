class Organization
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :departments
  has_many :roles

  has_one :project_setting
  field :project_setting_id, type: BSON::ObjectId

  field :name, type: String
end
