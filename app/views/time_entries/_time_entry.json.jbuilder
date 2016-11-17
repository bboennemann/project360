json.extract! time_entry, :id, :entry_date, :hours, :created_at, :updated_at
json.url time_entry_url(time_entry, format: :json)