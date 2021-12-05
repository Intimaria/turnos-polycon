class Export
    include ActiveModel::Model
    include ActiveModel::Validations
    attr_accessor :professional, :date, :type
    validates :date, :type, presence: true
    validates :date, timeliness: { type: :datetime }
  
  end