# belongs_to :project
# belongs_to :organization
# belongs_to :client
# belongs_to :department

rails g scaffold project_settings default_hours_per_day:float workdays:array default_currency:string project_id:string organization_id:string client_id:string department_id:string