
class ProfessionalForExport < ActiveModel::Type::Value
  def cast(value)
      professional = value.present? ? Professional.find(value) : nil
      super(professional)
    end 
  end


ActiveModel::Type.register(:professional, ProfessionalForExport)



class Export
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations


  attribute :date, :date
  attribute :professional, :professional
  attribute :type, :string

  attr_accessor :professional, :date, :type


  validates :date, :type, presence: true
  validates :date, timeliness: { type: :date }
  validates :type, inclusion: { in: [:day, :week] }




end 


