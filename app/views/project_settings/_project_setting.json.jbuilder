json.extract! project_setting, :id, :default_hours_per_day, :workdays, :default_currency, :project_id, :organization_id, :client_id, :department_id, :created_at, :updated_at
json.url project_setting_url(project_setting, format: :json)