class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,  :trackable, 
         :recoverable, :rememberable, :validatable
  
  validates :role, presence: true
  validates :username, presence: true

  enum role: [:user, :admin]
end
