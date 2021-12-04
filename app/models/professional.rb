class Professional < ApplicationRecord
    has_many :appointments, dependent: :destroy
    has_many :valid_appointments, -> { where(active: true).where("date > ?", Date.yesterday) }, class_name: 'Appointment'
    validates :name, :title, :surname, presence: true, length: {maximum: 255}
    validates :active, inclusion: { in: [true, false] }

    scope :active, -> {where(active: true)}

    def to_s
        "#{title} #{name.first}. #{surname}"
    end 

end
