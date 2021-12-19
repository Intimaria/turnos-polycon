class Appointment < ApplicationRecord
  belongs_to :professional, -> { where active: true }, counter_cache: :total
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


  def valid_and_future
    active && date > Date.yesterday
  end

  def appointee
    "#{name} #{surname}"
  end

  def soft_delete
    active = false
  end


  #  use cron jobs to clear old appointments
  def logical_past_date
    if date > Date.yesterday
      active = false
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

end
