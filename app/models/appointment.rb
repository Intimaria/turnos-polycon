class Appointment < ApplicationRecord
    belongs_to :professional
    validates :name, :phone, :surname, presence: true, length: {maximum: 255}
    validates :date, timeliness: { on_or_after: lambda { Date.current }, type: :datetime }, 
                uniqueness: {scope: :professional_id}
    validates :active, inclusion: { in: [true, false] }

    scope :active, -> {where(active: true)}
    scope :order_by_latest_first, -> { order(date: :asc)}

    after_create :increment_total_count
    after_destroy :decrement_total_count

    def appointee
        "#{name} #{surname}"
    end 

    def logical_past_date
        if date > Date.yesterday
            active = false 
            decrement_total_count
        end
    end 

    def physical_past_date
        if date > Date.yesterday
            destroy
        end
    end 
    
    private 


    def increment_total_count 
        professional.increment(:total, 1).save
    end 

    def decrement_total_count 
        professional.decrement(:total, 1).save
    end 


end
