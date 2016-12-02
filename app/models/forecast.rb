class Forecast
  include Mongoid::Document

  belongs_to :project
  field :project_id, type: BSON::ObjectId

  belongs_to :user
  field :user_id, type: BSON::ObjectId

  has_many :user_forecasts, dependent: :destroy

  field :name, type: String
  field :revision, type: Integer, default: 0
  field :approval_status, type: String

  def total_hours
  	total_hours = 0
  	self.user_forecasts.each do |user_forecast|
  		total_hours = total_hours + user_forecast.total_hours
  	end
  	return total_hours
  end

  def total_amount
    total_amount = 0
    self.user_forecasts.each do |user_forecast|
      total_amount = total_amount + user_forecast.total_amount unless user_forecast.total_amount.nil?
    end
    return total_amount
  end

  def total_cost
    total_cost = 0
    self.user_forecasts.each do |user_forecast|
      total_cost = total_cost + user_forecast.total_cost unless user_forecast.total_cost.nil?
    end
    return total_cost
  end

  def approved_forecast project
    self.forecasts.each do |forecast|
      if forecast.approval_status == "approved"
        return forecast
        break
      end     
    end
  end

end
