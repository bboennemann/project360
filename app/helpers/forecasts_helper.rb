module ForecastsHelper
	def first_monday_of_this_week
		today = Date.today
		return today - today.cwday + 1
	end

	def day_name_short(date)
		weekdays = {1 => "Mon", 2 => "Tue", 3 => "Wed", 4 => "Thu", 5 => "Fri", 6 => " ", 7 => " "}
		weekdays[date.cwday]
	end

	def day_style(date)
		case date.cwday
		when 6,7
			return "style='background: silver;'".html_safe
		end
	end
end
