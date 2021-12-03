class Appointment < ApplicationRecord
    belongs_to :professional, required: true
    validates :name, presence: true, length: {maximum: 255}
    validates :surname, presence: true, length: {maximum: 255}
    validates :phone, presence: true, length: {maximum: 255}
    validates :date, timeliness: { on_or_after: lambda { Date.current }, type: :datetime }
    validates :active, inclusion: { in: [true, false] }

    scope :active, -> {where(active: true)}
    scope :order_by_latest_first, -> { order(date: :desc)}

    after_create :post_log_message
    after_create :update_total_count

    def appointee
        "#{name} #{surname}"
    end 

    private 

    def post_log_message
        puts "Appointment created with id #{id} for professional with id of #{professional_id}"
    end

    def update_total_count 
        professional.increment(:total, 1).save
    end 



end
