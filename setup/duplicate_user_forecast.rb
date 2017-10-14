uf = UserForecast.first

75.times do |i|
	u2 = uf.clone
	u2.save
	
end