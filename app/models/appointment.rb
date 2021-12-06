class Appointment < ApplicationRecord
  belongs_to :professional
  validates :name, :phone, :surname, presence: true, length: { maximum: 255 }
  validates :date, timeliness: { on_or_after: lambda { Date.current }, type: :datetime },
                   uniqueness: { scope: :professional_id }
  validates :active, inclusion: { in: [true, false] }
  validate :date, :not_weekend, on: :create
  validates_time :time, :on_or_after => '8:00am',
                        :on_or_after_message => 'Appointments only during working hours (08:00-17:00hs)',
                        :before => '17:00pm',
                        :allow_nil => false

  scope :active, -> { where(active: true) }
  scope :order_by_latest_first, -> { order(date: :asc) }
  scope :all_valid_appointments, -> { where(active: true).where("date > ?", Date.yesterday) }

  after_create :increment_total_count
  after_destroy :decrement_total_count

  def valid_and_future
    active && date > Date.yesterday
  end

  def appointee
    "#{name} #{surname}"
  end

  def soft_delete
    active = false
    decrement_total_count
  end


  def self.search(search)
    if search 
        app = Appointment.find_by(date: search)
        if app 
            self.where(id: app)
        else 
            Appointment.all
        end 
    else 
        Appointment.all
    end 
  end 

  #  use cron jobs to clear old appointments
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
    if date.saturday? || date.sunday?
      errors.add(:date, 'No appointments on weekends.')
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
