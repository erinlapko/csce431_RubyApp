class Meeting < ApplicationRecord
    has_many :members, through: :attendances
    has_many :attendances, dependent: :destroy

    validates :time, :title, :description, :points, presence: true
end
