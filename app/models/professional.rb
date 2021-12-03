class Professional < ApplicationRecord
    has_many :appointments
    validates :name, presence: true, length: {maximum: 255}
    validates :surname, presence: true, length: {maximum: 255}
    validates :title, presence: true, length: {maximum: 255}
    validates :active, in: {true, false}
end
