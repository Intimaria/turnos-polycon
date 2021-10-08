module Polycon
  module Model 
    class Error < StandardError; def message; end; end 

    class ParameterError < Error 
      def message
        "there is something wrong with the sent parameters"
      end
    end
    class NotFound < Error 
      def message
        "what you are looking for is not to be found"
      end
    end
    class AlreadyExists <Error
      def message
        "what you wish to create already exists"
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

  end 
end 