class Professional < ApplicationRecord
    has_many :appointments, dependent: :destroy
    validates :name, :title, :surname, presence: true, length: {maximum: 255}
    validates :active, inclusion: { in: [true, false] }

    scope :active, -> {where(active: true)}

    def to_s
        "#{title} #{name.first}. #{surname}"
    end 

end
