module ApplicationHelper
		def approved_forecast project
		project.forecasts.each do |forecast|
			if forecast.approval_status == "approved"
				return forecast
			end			
		end
	end
end
