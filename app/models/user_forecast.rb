class UserForecast
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :forecast
  field :forecast_id, type: BSON::ObjectId

  belongs_to :project
  field :project_id, type: BSON::ObjectId

  belongs_to :project_role
  field :project_role_id, type: BSON::ObjectId

  belongs_to :user
  field :user_id, type: BSON::ObjectId

  embeds_many :time_entries
  accepts_nested_attributes_for :time_entries
  
  field :published, type: Mongoid::Boolean

  def total_hours
    self.time_entries.inject(0) { |sum, te| sum + te[:hours] }
  end

  def total_amount
    unless self.project_role.rate.nil?
      self.total_hours * self.project_role.rate
    end
  end

  def total_cost
    unless self.project_role.cost.nil?
      self.total_hours * self.project_role.cost
    end
  end

end
