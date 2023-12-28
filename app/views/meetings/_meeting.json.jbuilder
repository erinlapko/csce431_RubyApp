json.extract! meeting, :id, :title, :time, :description, :points, :created_at, :updated_at
json.url meeting_url(meeting, format: :json)
