class Project
  include Mongoid::Document

  belongs_to :department
  field :department_id, type: BSON::ObjectId

  belongs_to :client
  field :client_id, type: BSON::ObjectId

  has_many :project_roles

  has_many :forecasts

  has_many :user_forecasts

  field :name, type: String
  field :start_date, type: Date
  field :end_date, type: Date
  field :active, type: Mongoid::Boolean

  def approved_forecast
    forecast = nil
    self.forecasts.each do |forecast|
      if forecast.approval_status == "approved"
        return forecast
      end
    end
  end
end
