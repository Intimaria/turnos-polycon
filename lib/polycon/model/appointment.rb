# frozen_string_literal: true
require 'date'
require 'time'

module Polycon
  module Model

    class Appointment
      attr_accessor :date, :professional, :name,  :surname, :phone, :notes, :path
      FORMAT = '%Y-%m-%d_%H-%M' 
      class << self 


        def all(professional:, date: nil)
          Polycon::Store::ensure_root_exists
          prof = Professional.create(name: professional)
          raise InvalidProfessional unless prof.valid?
          appointments  = Polycon::Store::entries(prof.path)
          if date then 
            raise InvalidDate unless valid_date?(date)
            appointments.filter! {|appt| appt.date == date }
          end 
          appointments
        end 

        def create(date:, professional:, **options)
          begin 
            Polycon::Store::ensure_root_exists
            path = make_path(professional: professional, date: date)
            raise AlreadyExists if Polycon::Store::exist?(path)
            raise AppointmentCreationError unless appointment = new(date: date, professional: professional, **options)
            valid?(date: appointment.date, professional: appointment.professional)
            appointment
          end
        end 

        def from_file(date:, professional:)
          Polycon::Store::ensure_root_exists
          path = make_path(professional: professional, date: date)
          raise NotFound unless  Polycon::Store::exist?(path)
          surname, name, phone, notes = Polycon::Store::read(path)
          appointment = create(date:date, professional:professional, name:name, surname:surname, phone:phone, notes:notes)
          appointment
        end

        def make_path(professional:, date:)
          name, surname = professional.split(" ")
          directory = (name + "_" + surname + '/').upcase
          file = Time.parse(date).strftime(FORMAT)+'.paf'
          directory+file
        end 
  

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
            d = DateTime.new(date)
            d.strptime(date.to_s, FORMAT)
            true  
          rescue
            false 
          end 
        end 

  
      end 

      def initialize(date:, professional:, **options)
        @path = Appointment.make_path(professional: professional, date: date)
        self.date = Time.parse(date)
        self.professional = Professional.create(name: professional)
        options.each do |key, value|
          self.send(:"#{key}=", value)
        end
      end

      def cancel(date:, professional:)
        Polycon::Store::ensure_root_exists
      end

      def cancel_all(professional:)
        Polycon::Store::ensure_root_exists
      end

      def reschedule(old_date:, new_date:, professional:)
        Polycon::Store::ensure_root_exists
      end

      def edit(date:, professional:, **options)
        Polycon::Store::ensure_root_exists
      end 

      def to_s 
          "Date: #{@date} for client: #{@surname}, #{@name}"
      end 

      def save()
        Polycon::Store::save(appointment: self)
      end 
    
      #Appointment Errors
        class AppointmentError < Error 
          def message; end; end 

        class AppointmentCreationError < AppointmentError
          def message; end
        end 

        class InvalidAppointment < AppointmentError 
          def message
            'the appointment is invalid'
          end 
        end

        class InvalidAppointmentDate < InvalidAppointment 
          def message
            'the date is invalid'
          end 
        end

        class InvalidAppointmentProfessional < InvalidAppointment 
          def message
            'the date is invalid'
          end 
        end
        
    end 
  end
end
