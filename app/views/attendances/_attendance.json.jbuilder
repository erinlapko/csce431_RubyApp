json.extract! attendance, :id, :meeting_id, :member_id, :att_time, :created_at, :updated_at
json.url attendance_url(attendance, format: :json)
