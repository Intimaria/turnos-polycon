# frozen_string_literal: true
require 'time'

module Polycon
  module Model
    # This class's responsability is to model Appointment objects
    class Appointment
      attr_accessor :date, :professional, :name, :surname, :phone, :notes
      attr_reader :path

      FORMAT = '%Y-%m-%d_%H-%M'
      class << self


        def all(professional:, date: nil)
          prof = Professional.create(name: professional)
          raise InvalidProfessional unless Professional.valid?(prof)
          all_dates  = Polycon::Store::entries(directory:Polycon::Store::professional_path(professional))
          all_dates.map! do |appt| 
            date_arr = appt.split(/_/)
            time = date_arr[1].gsub(/[-]/,":")
            date_arr[0]+"_"+time
          end 
          appointments = []
          all_dates.each {|date| appointments << Appointment.from_file(date: date, professional: professional)}
          appointments.sort_by { |a| a.date }
        end 

        def create(date:, professional:, **options)
            raise AppointmentCreationError unless (appointment = new(date: date, professional: professional, **options))

            valid?(date: appointment.date, professional: appointment.professional)
            appointment
          end
        end 

        def from_file(date:, professional:)
          surname, name, phone, notes = Polycon::Store.read(professional: Professional.create(name: professional), date: Time.parse(date))
          create(date:date, professional: professional, name: name, surname: surname, phone: phone, notes: notes)
        end

        def cancel_all(professional:)
          prof = Professional.create(name: professional)
          raise NotFound if Polycon::Store.empty?(directory:prof.path)

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
        @path = Polycon::Store.appointment_path(professional: professional, date: date)
        self.date = Time.parse(date)
        self.professional = Professional.create(name: professional)
        options.each do |key, value|
          self.send(:"#{key}=", value)
        end
      end
      
      def to_h
        {
        :professional=> "#{professional.name professional.surname}",
        :date=>date.to_s,
        :surname=>surname,
        :name=>name,
        :phone=>phone,
        #:path=>path,
        :notes=>notes}
      end 


      def edit(**options)
        Polycon::Store.modify(file: self, **options)
      end 
      def cancel()
        Polycon::Store.delete(@path)
        raise AppointmentDeletionError if Polycon::Store::exist?(@path)
      end
      def reschedule(new_date:)
        new_path =  Polycon::Store.appointment_path(professional:self.to_h[:professional], date: new_date)
        raise AlreadyExists if Polycon::Store.exist?(new_path)
        Polycon::Store.rename(old_name: @path, new_name: new_path)
      end

      def to_s 
        s = String.new
        self.to_h.each {|key,value| s << "#{key}: #{value}\n"}
        s
      end 

      def save()
        path = Polycon::Store.appointment_path(professional:self.to_h[:professional], date: @date)
        raise AlreadyExists if Polycon::Store::exist?(path)
        Polycon::Store.save(appointment: self)
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
        
    end 
  end
end
