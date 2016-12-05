module UserForecastsHelper
	def day_total_hours_for_review(user_forecasts, date)
		total_time = 0
		user_forecasts.each do |user_forecast|
			if (user_forecast.approval_status == "approved"  && (user_forecast.project_id != @forecast.project_id)) || ((user_forecast.approval_status == "requested") && (user_forecast.project_id == @forecast.project_id))  
				time_entry = user_forecast.time_entries.detect {|te| te.entry_date == date}
				if time_entry
					total_time = total_time + time_entry.hours
				end
			end
		end
		return total_time
	end

	def day_total_hours(user_forecasts, date)
		total_time = 0
		user_forecasts.each do |user_forecast|
			time_entry = user_forecast.time_entries.detect {|te| te.entry_date == date}
			if time_entry
				total_time = total_time + time_entry.hours
			end
		end
		return total_time
	end

	def day_total_value(user_forecasts, date)
		#! needs refactoring. shouldn't this be on the Forecast.user_forecasts....?
		total_value = 0
		user_forecasts.each do |user_forecast|
			time_entry = user_forecast.time_entries.detect {|te| te.entry_date == date}
			if time_entry
				total_value = total_value + time_entry.hours * user_forecast.project_role.rate
			end
		end
		return total_value
	end

	def period_total_value(user_forecasts, start_date, end_date)
		#! needs refactoring. shouldn't this be on the Forecast.user_forecasts....?
		period_total_value = 0
		while start_date < end_date do
			period_total_value += day_total_value(user_forecasts, start_date)
			start_date +=1
		end
		return period_total_value
	end
end
