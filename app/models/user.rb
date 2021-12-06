class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :trackable, :rememberable, :validatable

  validates :role, presence: true
  validates :username, presence: true, uniqueness: true

  enum role: [:user, :manager, :admin]
end
