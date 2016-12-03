module ForecastsHelper
	def monday_of_week date
		return (date - date.cwday + 1)
	end

	def day_name_short(date)
		weekdays = {1 => "Mon", 2 => "Tue", 3 => "Wed", 4 => "Thu", 5 => "Fri", 6 => " ", 7 => " "}
		weekdays[date]
	end

	def day_style(date)
		if date.cwday == 6 || date.cwday == 7
			return "style='background: silver;'".html_safe
		end
	end

end


 