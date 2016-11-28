module UserForecastsHelper
	def day_total(user_forecasts, date)
		total_time = 0
		user_forecasts.each do |user_forecast|
			time_entry = user_forecast.time_entries.detect {|te| te.entry_date == date}
			if time_entry
				total_time = total_time + time_entry.hours
			end
		end
		return total_time
	end
end
