class Organization
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :departments

  field :name, type: String
end
