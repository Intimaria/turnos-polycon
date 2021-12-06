class Professional < ApplicationRecord
    has_many :appointments, dependent: :destroy
    has_many :valid_appointments, -> { where(active: true).where("date > ?", Date.yesterday) }, class_name: 'Appointment'
    validates :name, :title, :surname, presence: true, length: {maximum: 255}
    validates :active, inclusion: { in: [true, false] }
    before_destroy :can_destroy?, prepend: true
    before_destroy { throw(:abort) if errors.present? }

    

    scope :active, -> {where(active: true)}


    def to_s
        "#{title} #{name.first}. #{surname}"
    end 

    def appointments?
      total > 0
    end 

    protected 

    def can_destroy?
        if total > 0
            errors.add(:base, "This professional cannot be deleted, they still have appointments.") 
            throw :abort
        end 
    end


end
