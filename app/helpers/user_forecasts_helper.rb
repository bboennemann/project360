module UserForecastsHelper
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
		total_value = 0
		user_forecasts.each do |user_forecast|
			time_entry = user_forecast.time_entries.detect {|te| te.entry_date == date}
			if time_entry
				total_value = total_value + time_entry.hours * user_forecast.project_role.rate
			end
		end
		return total_value
	end
end
