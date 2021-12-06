class Export
  include ActiveModel::Model
  include ActiveModel::Validations
  validates :date, :type, presence: true
  validates :date, timeliness: { type: :datetime }
  attr_accessor :professional, :date, :type

  def initialize(attributes = {})
    super
    if !attributes.empty?
      @date = Date.parse(attributes["date"])
      @type = attributes["type"].to_sym
      if attributes["professional"].blank?
        @professional = nil
      else
        @professional = Professional.find(attributes["professional"])
      end
    end
  end
end
