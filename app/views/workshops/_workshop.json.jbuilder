json.extract! workshop, :id, :name, :description, :zoom_link, :time, :created_at, :updated_at
json.url workshop_url(workshop, format: :json)
