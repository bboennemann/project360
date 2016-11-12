# project
# has_one person as owner
# belongs_to client
# belongs_to organization
# belongs_to department
# has_many persons # rates through person.project_role
# has_many forecasts
rails g scaffold project name:string start_date:date end_date:date active:boolean