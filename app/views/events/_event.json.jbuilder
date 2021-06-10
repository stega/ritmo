json.extract! event, :id, :name, :description, :zoom_link, :time, :created_at, :updated_at
json.url event_url(event, format: :json)
