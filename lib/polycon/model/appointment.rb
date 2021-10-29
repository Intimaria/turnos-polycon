# frozen_string_literal: true
require 'time'

# requires for testing 
require_relative 'error'
require_relative '../store'

module Polycon
  module Model
    # This class's responsability is to model Appointment objects
    class Appointment
      attr_accessor :date, :professional, :name, :surname, :phone, :notes

      FORMAT = '%Y-%m-%d_%H-%M'
      class << self


        def all(prof)
          #TODO maybe have professional know their appointments, or store return
          #TODO maybe save hour separately from date 
          raise InvalidProfessional unless Professional.valid?(prof)
          appointments = Polycon::Store.all_appointment_dates(prof)
          appointments.map! {|date| Appointment.from_file(date: date, professional: prof)}
        end 

        def create(date:, professional:, **options)
            raise AppointmentCreationError unless (appointment = new(date: date, professional: professional, **options))

            valid?(date: appointment.date, professional: appointment.professional)
            appointment
        end
        

        def from_file(date:, professional:)
          surname, name, phone, notes = Polycon::Store.read(professional: Professional.create(name: professional), date: Time.parse(date))
          create(date:date, professional: professional, name: name, surname: surname, phone: phone, notes: notes)
        end

        def cancel_all(professional:)
          prof = Professional.create(name: professional)
          raise AppointmentNotFoundError unless prof.appointments?

          all_appointments = all(professional: professional)
          all_appointments.each {|appt| appt.cancel} # &:cancel
        end

        #utility

        protected 

        def valid? (date:, professional:)
          begin 
            valid_professional?(professional) && valid_date?(date)
          rescue 
            false 
          end 
        end 

        def valid_professional?(professional)
          begin 
            (professional && Professional.valid?(professional))
          rescue 
            false 
          end 
        end   

        def valid_date?(date)
          begin 
            Time.strptime(date.to_s, FORMAT)
            true  
          rescue
            false 
          end 
        end 

      end 

      def initialize(date:, professional:, **options)
        self.date = Time.parse(date)
        self.professional = Professional.create(name: professional)
        options.each do |key, value|
          self.send(:"#{key}=", value)
        end
      end
      
      def to_h
        {
        :professional=> professional,
        :date=>date.to_s,
        :surname=>surname,
        :name=>name,
        :phone=>phone,
        :notes=>notes}
      end 


      def edit(**options)
        Polycon::Store.modify(self, **options)
      end 

      def cancel()
        Polycon::Store.delete_appointment(self)
        raise AppointmentDeletionError if Polycon::Store.exist_appointment?(self)
      end

      def reschedule(new_date:)
        copy = self
        copy.date = Time.parse(new_date)
        raise AlreadyExists if Polycon::Store.exist_appointment?(copy)

        Polycon::Store.rename_appointment(old_app: self, new_app: copy)
      end

      def to_s 
        s = String.new
        self.to_h.each {|key,value| s << "#{key}: #{value}\n"}
        s
      end 

      def save()
        raise AlreadyExists if Polycon::Store.exist_appointment?(self)
        Polycon::Store.save_appointment(self)
      end 
    
       # Appointment Errors: General
        class AppointmentError < Error
          def message; end; end 

       # Appointment Errors: Create
        class AppointmentCreationError < AppointmentError
          def message; end
        end 

      # Appointment Errors: Delete
        class AppointmentDeletionError < AppointmentError
          def message; end
        end 

       # Appointment Errors: Invalid
        class InvalidAppointment < AppointmentError 
          def message
            'the appointment is invalid'
          end 
        end

      # Appointment Errors: Invalid Date
        class InvalidAppointmentDate < InvalidAppointment 
          def message
            'the date is invalid'
          end 
        end

        # Appointment Errors: Invalid Professional
        class InvalidAppointmentProfessional < InvalidAppointment 
          def message
            'the profess is invalid'
          end 
        end

        # Appointment Errors: Not found
        class AppointmentNotFoundError < NotFound
        def message
          "the appointment(s) you are looking for are not to be found"
        end 
      end 
        
    end 
  end
end
