class Professional < ApplicationRecord
    has_many :appointments
    validates :name, presence: true, length: {maximum: 255}
    validates :surname, presence: true, length: {maximum: 255}
    validates :title, presence: true, length: {maximum: 255}
    validates :active, inclusion: { in: [true, false] }

    scope :active, -> {where(active: true)}

    def to_s
        "#{title} #{name.first}. #{surname}"
    end 

end
