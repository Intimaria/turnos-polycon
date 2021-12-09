class Export
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Attributes
  attribute :date, :date
  attribute :professional, class: "Professional"

  attr_accessor :professional, :date, :type

  validates :date, :type, presence: true
  validates :date, timeliness: { type: :datetime }
  validates :professional, presence: false


end