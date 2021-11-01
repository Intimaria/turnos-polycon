module Polycon
  module Export
    def self.export_day(appointments:, **options)
      puts "here I export all the appointmets for a day"
    end  
    def self.export_week(appointments:, **options)
      puts "here I export all the appointments for a week"
    end 
    #Export Errors
    class ExportError 
      def message
        "there was a problem processing your export"
      end; 
    end 
  end 
end 
