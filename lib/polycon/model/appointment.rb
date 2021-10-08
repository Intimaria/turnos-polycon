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
          prof = Polycon::Model::Professional.create(name: professional)
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
            raise AppointmentCreationError unless appointment = new(date: date, professional: professional, **options)
            valid?(date: appointment.date, professional: appointment.professional)
            appointment
          end
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
          puts "in validatn of professional"
          begin 
            (professional && Polycon::Model::Professional.valid?(professional))
          rescue 
            false 
          end 
        end   

        def valid_date?(date)
          puts "in validation of time"
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
        self.date = Time.parse(date)
        puts @date
        self.professional = Polycon::Model::Professional.create(name: professional)
        puts @professional
        @path = self.professional.path+self.date.strftime(FORMAT)+'.paf'
        options.each do |key, value|
          self.send(:"#{key}=", value)
        end
      end


      def from_file(date:, professional:)
        Polycon::Store::ensure_root_exists
        obj = new(date: date, professional: professional)
        appointment = Polycon::Store::read(obj)
        raise InvalidAppointment unless (appointment && appointment.valid?)
        appointment
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
          "Date: #{self.date.to_s} appt for client =>/"
          "#{self.surname}, #{self.name} with: /"
          "#{self.professional.surname}, #{self.professional.name}/"
          "#{self.notes unless self.notes.nil?}"
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
