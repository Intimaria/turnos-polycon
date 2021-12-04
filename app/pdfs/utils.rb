require 'date'
module Utils 
    def self.horarios(start_of_day)
        d1 = DateTime.parse("#{Date.today.to_s}  #{start_of_day}")
        slots = []
        d2 = d1 + 0.40
        d1.step(d2, 1/48r) { |d| slots << d.strftime('%H:%M') }
        slots
      end
  
      def self.get_appointments(professional: nil)
          if professional
            appts = professional.valid_appointments
          else
            appts = Appointment.all_valid_appointments
          end
        end 
end 
