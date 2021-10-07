module Polycon
  module Model 
    class Error < StandardError; def message; end; end 


    class NotFound < Error 
      def message
        "What you are looking for is not to be found"
      end
    end
    class AlreadyExists <Error
      def message
        "What you wish to create already exists"
      end
    end 

    #Appointment 
    class AppointmentError < Error 
      def message; end; end 

    class AppointmentCreationError < AppointmentError
      def message; end 
    end 

    class InvalidAppointment < AppointmentError 
      def message
        'the appointment is invalid. Please revise'
      end 
    end


    #Professional 
    class ProfessionalError <Error 
      def message; end; end 

    class ProfessionalCreationError < Error
      def message 
        "Could not create professional."
      end 
    end 
    class ProfessionalRenameError < Error
      def message 
        "Could not rename professional."
      end 
    end 
 
    class InvalidProfessional < ProfessionalError 
      def message 
        'the professional is invalid. Please revise'
      end 
    end 
  end 
end 