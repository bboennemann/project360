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
  
  field :approval_status, type: String
  field :rate, type: Float, default: 0.0
  field :total_hours, type: Float, default: 0.0



  def get_total_hours old_value, new_value
    total_hours = self.total_hours - old_value + new_value.to_f
    total_hours.round(2)
  end

  
  def day_hours date_entry
    time_entry = self.time_entries.detect {|te| te.entry_date == date_entry}
    #time_entry = self.binary_search_date(date_entry)
    if time_entry
      time_entry.hours.round(2)
    else
      time_entry = 0
    end
  end

  
  def total_amount
    #unless self.project_role.rate.nil?
      amount = self.total_hours * self.project_role.rate
      amount.round(2)
    #end
  end

  
  def day_amount date_entry, rate
    day_amount = 0
      time_entry = self.time_entries.detect {|te| te.entry_date == date_entry}
      #time_entry = self.binary_search_date(date_entry)
      if time_entry
        day_amount = time_entry.hours * rate 
      end
    return day_amount.round(2)
  end

  
  def period_hours start_date, end_date
    #get first index
    first_index = 0
    while self.time_entries[first_index].entry_date < start_date
      first_index += 1      
    end

    period_hours = 0

    while start_date < end_date do
      period_hours += self.time_entries[first_index].hours 

      #period_amount += self.day_amount(start_date, rate)

      start_date += 1
      first_index += 1
    end
    return period_hours
  end

  # requires a sorted list of time entries!
  def period_amount start_date, end_date
    rate = self.rate
    return 0 if rate == 0
    return 0 if rate == nil
   
    last_index = self.time_entries.size - 1
    return 0 if self.time_entries[last_index].entry_date < start_date # don't even look any further

    period_hours = period_hours(start_date, end_date)

    period_amount = period_hours * rate

    return period_amount.round(2)
  end

  def total_cost
    unless self.project_role.cost.nil?
      cost = self.total_hours * self.project_role.cost
      cost.round(2)
    end
  end

  def total_result
    result = total_amount - total_cost
    result.round(2)
  end

  def binary_search_date(date, from=0, to=nil)
    #! currently not used. running into 'stack too deep' errors
    return 0 if self.time_entries == nil

    if to == nil
        to = self.time_entries.count - 1
    end

    mid = (from + to) / 2


    if date < self.time_entries[mid].entry_date
        return binary_search_date date, from, mid - 1
    elsif date > self.time_entries[mid].entry_date
        return binary_search_date date, mid + 1, to
    else
        #return self.time_entries[mid]
        return mid #returning the index
    end
  end


end
