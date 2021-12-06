class Export
    include ActiveModel::Model
    include ActiveModel::Validations
    validate :date, :not_blank_date
    validate :type, :not_blank_type
    validates :date, timeliness: { type: :datetime }
    attr_accessor :professional, :date, :type

    def no_blank_date
        if date.blank?
            errors.add(:date, 'Date cannot be left blank.') 
        end
    end 
    def no_blank_type
        if type.blank?
            errors.add(:type, 'Type cannot be left blank.') 
        end
    end 

    def initialize(attributes={})
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