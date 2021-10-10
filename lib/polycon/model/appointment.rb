# frozen_string_literal: true
require 'date'
require 'time'

module Polycon
  module Model

    class Appointment
      attr_accessor :date, :professional, :name,  :surname, :phone, :notes
      attr_reader :path
      FORMAT = '%Y-%m-%d_%H-%M' 
      class << self 


        def all(professional:, date: nil)
          Polycon::Store::ensure_root_exists
          prof = Professional.create(name: professional)
          raise InvalidProfessional unless Professional.valid?(prof)
          appointments  = Polycon::Store::entries(directory:Polycon::Store::PATH+prof.path)
          if date then 
            begin 
              in_date = Date.parse(date)
            rescue 
              raise ParameterError, "the date parameter is invalid"
            end 
            appointments.filter! do  |appt| 
              Date.parse(appt) == in_date
            end 
          end 
          appointments.map! do |appt| 
            date_arr = appt.split(/_/)
            time = date_arr[1].gsub(/[-]/,":")
            date_arr[0]+"_"+time
          end 
          all = []
          appointments.each {|appt| all << Appointment.from_file(date: appt, professional: professional)}
          all
        end 

        def create(date:, professional:, **options)
          begin 
            Polycon::Store::ensure_root_exists
            path = make_path(professional: professional, date: date)
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

        def cancel_all(professional:)
          Polycon::Store::ensure_root_exists
          prof = Professional.create(name: professional)
          raise NotFound if Polycon::Store::empty?(directory:prof.path)
          all_appointments = all(professional: professional)
          all_appointments.each do |appt| 
            date = appt.date.to_s.split(' ')
            cancel(professional: professional, date: date[0]+' '+date[1] )
          end 
        end

        #if this was an instance method, it would only receive the new date
        #it would then not need to make a path or ensure it exists
        #commands would need to fetch it from file and tell it to reschedule itself 
        def reschedule(old_date:, new_date:, professional:)
          Polycon::Store::ensure_root_exists
          old_path = make_path(professional:professional, date: old_date)
          raise NotFound unless Polycon::Store::exist?(old_path)
          new_path = make_path(professional:professional, date: new_date)
          Polycon::Store::rename(old_name: old_path, new_name: new_path)
        end

        #if this was instance method it would not receive parameters
        #the commands would fetch it from file and then ask it to cancel itself 
        def cancel(date:, professional:)
          Polycon::Store::ensure_root_exists
          path = make_path(professional:professional, date: date)
          raise NotFound unless Polycon::Store::exist?(path)
          Polycon::Store::delete(path)
          raise AppointmentDeletionError if Polycon::Store::exist?(path)
        end

        #utility

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
      
      def to_h
        {:date=>date.to_s,
        :professional=>professional.name+' '+professional.surname,
        :surname=>surname,
        :name=>name,
        :phone=>phone,
        :path=>path,
        :notes=>notes}
      end 


      def edit(**options)
        Polycon::Store::ensure_root_exists
        Polycon::Store::modify(file: self, **options)
      end 

      def to_s 
          "Date: #{@date} for client: #{@surname}, #{@name}"
      end 

      def save()
        Polycon::Store::ensure_root_exists
        raise AlreadyExists if Polycon::Store::exist?(self.path)
        Polycon::Store::save(appointment: self)
      end 
    
      #Appointment Errors
        class AppointmentError < Error 
          def message; end; end 

        class AppointmentCreationError < AppointmentError
          def message; end
        end 

        class AppointmentDeletionError < AppointmentError
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
