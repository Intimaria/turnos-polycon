class Export
    include ActiveModel::Model
    include ActiveModel::Validations
    validates :date, :type, presence: true
    validates :date, timeliness: { type: :datetime }
    attr_accessor :professional, :date, :type
    def initialize(attributes={})
        super
        puts "export initialized with #{attributes}"
      end
  end