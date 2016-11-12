# time_entry
# times are recorded in hours. can be converted to days, depending on FE configuration
# blongs_to person
# belongs_to project
# belongs_to forecast
rails g scaffold time_entry entry_date:date hours:float