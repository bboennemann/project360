uf = UserForecast.first

15.times do |i|
	u2 = uf.clone
	u2.save
	
end