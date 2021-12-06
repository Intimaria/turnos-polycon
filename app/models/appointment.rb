class Appointment < ApplicationRecord
    belongs_to :professional
    validates :name, :phone, :surname, presence: true, length: {maximum: 255}
    validates :date, timeliness: { on_or_after: lambda { Date.current }, type: :datetime }, 
                uniqueness: {scope: :professional_id}
    validates :active, inclusion: { in: [true, false] }
    validate :date, :not_weekend, on: :create
    validate :time, :within_working_hours, on: :create

    scope :active, -> {where(active: true)}
    scope :order_by_latest_first, -> { order(date: :asc)}

    after_create :increment_total_count
    after_destroy :decrement_total_count

    def self.all_valid_appointments
        all.where(active: true).where("date > ?", Date.yesterday)
    end 

    def appointee
        "#{name} #{surname}"
    end 

    # use cron jobs to clear old appointments 
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
    
    def not_weekend 
        if date.saturday? ||date.sunday?
            errors.add(:date, 'No appointments on weekends.') 
        end
    end 

    def within_working_hours
        if !(time.between? Time.new.change(hour: 8), Time.new.change(hour: 17))
            errors.add(:time, 'Appointments only during working hours (08:00-17:00hs).') 
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
