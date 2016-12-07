class ProjectSetting
  include Mongoid::Document

  belongs_to :project
  field :project_id, type: BSON::ObjectId

  belongs_to :organization
  field :organization_id, type: BSON::ObjectId

  belongs_to :client
  field :client_id, type: BSON::ObjectId

  belongs_to :department
  field :department_id, type: BSON::ObjectId

  field :default_hours_per_day, type: Float, default: 8
  field :workdays, type: Array, default: [1,2,3,4,5]
  field :default_currency, type: String , default: 'USD'
  
end
