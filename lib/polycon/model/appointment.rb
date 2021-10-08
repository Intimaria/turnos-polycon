# frozen_string_literal: true

module Polycon
  module Model

    class Appointment
      attr_accessor :date, :professional, :name,  :surname, :phone, :notes
      
      class << self 
        FORMAT = '%Y-%m-%d_%H-%M'

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
          raise InvalidAppointment unless (appointment.valid? (date: date, professional: professional))
          raise AppointmentCreationError unless (appointment = new(date: date, professional: professional, **options))
          #puts "creating Appointment for #{professional} on #{date}"
          appointment.save()
          appointment
        end

        protected 

        def valid? (date:, professional:)
          valid_professional? && valid_date?
        end 

        def valid_professional?(professional)
            professional && professional.valid?
            true 
          rescue 
            false 
        end   

        def valid_date?(date)
            Date.strptime(date.to_s, FORMAT)  
            true 
          rescue 
            false 
        end
      end 

      def initialize(date:, professional:, **options)
        self.date = Time.new(date)
        self.professional = Polycon::Model::Professional.create(name: professional)
        options.each do |key, value|
          self.send(:"#{key}", value)
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

      def to_s 
        "Date: #{self.date.to_s} appt for client =>"/
         "#{self.surname}, #{self.name} with: "/
         "#{self.professional.surname}, #{self.professional.name}"/
         "#{self.notes unless self.notes.nil?}"
      end 

      def save()
        Polycon::Store::save(appointment: self)
      end 


    end
  end
end
