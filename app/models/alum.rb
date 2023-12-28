class Alum < ApplicationRecord

    validates :name, :email, presence: true

end
