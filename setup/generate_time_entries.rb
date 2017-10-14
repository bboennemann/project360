@uf = UserForecast.first

date = Date.today

1000.times do |i|
	@uf.time_entries.new(entry_date: date, hours: 5.75)
	(i + 3) % 7 == 0 ? date = date + 3 : date = date + 1
end
@uf.save
