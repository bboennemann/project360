class Project
  include Mongoid::Document

  belongs_to :department
  field :department_id, type: BSON::ObjectId

  belongs_to :client
  field :client_id, type: BSON::ObjectId

  field :name, type: String
  field :start_date, type: Date
  field :end_date, type: Date
  field :active, type: Mongoid::Boolean
end
