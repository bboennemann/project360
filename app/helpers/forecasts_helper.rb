module ForecastsHelper
	def first_monday_of_week date
		return date - date + 1
	end

	def day_name_short(date)
		weekdays = {1 => "Mon", 2 => "Tue", 3 => "Wed", 4 => "Thu", 5 => "Fri", 6 => " ", 7 => " "}
		weekdays[date]
	end

	def day_style(date)
		case date.to_s.to_i % 7
		when 0,6
			return "style='background: silver;'".html_safe
		end
	end

	def get_value_from_forecast(user_forecast, date_entry)
		#! needs review. use of CWDate, long function names in HTML.erb files, etc.
		time_entry = user_forecast.time_entries.detect {|te| te.entry_date == date_entry}
		if time_entry
			time_entry.hours
		end
	end

	def day_value (user_forecast, date)
		hours = get_value_from_forecast(user_forecast, date) 
		hours.nil? ? nil : hours * user_forecast.project_role.rate 
	end

end


 