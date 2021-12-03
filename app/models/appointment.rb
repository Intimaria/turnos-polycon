class Appointment < ApplicationRecord
    belongs_to :professional, required: true
    validates :name, presence: true, length: {maximum: 255}
    validates :surname, presence: true, length: {maximum: 255}
    validates :phone, presence: true, length: {maximum: 255}
    validates :date, timeliness: { on_or_before: lambda { Date.current }, type: :datetime }
    validates :active, in: {true, false}
end
