module Polycon
  class Export < Prawn::Document
    # include Prawn::View
    
    def initialize(appointments:, **options)
      super(top_margin: 50)
      @appointments = appointments
      if options[:professional] 
        @professional = options[:professional] 
      end 
      table export(appointments: appointments, **options)
    end 
    def export(appointments:, **options)
      puts "here I export all the appointments - options for day week & professional"

    end 
=begin 
    def export_day(appointments:, **options)
      puts "here I export all the appointmets for a day"

    end  
    def export_week(appointments:, **options)
      puts "here I export all the appointments for a week"

    end  =end
    #Export Errors
    class ExportError 
      def message
        "there was a problem processing your export"
      end; 
    end 
  end 
end 
