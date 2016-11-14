class Organization
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :departments
  has_many :roles

  field :name, type: String
end
