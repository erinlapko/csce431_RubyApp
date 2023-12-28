class Attendance < ApplicationRecord
    belongs_to :member
    belongs_to :meeting

    validates :member_id, :meeting_id, presence: true

end
