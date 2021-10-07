# frozen_string_literal: true

module Polycon
  module Model

    class Appointment
      FORMAT = '%Y-%m-%d-%H-%M'
      attr_accessor :date, :professional, :name,  :surname, :phone, :notes

      def self.all(professional:, date: nil)
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

      def initialize(date:, professional:, **kwargs)
        self.date = Time.new(date)
        self.professional = Polycon::Model::Professional.create(name: professional)
        kwargs.each do |key, value|
          self.send(:"#{key}", value)
        end
      end

      def self.create(date:, professional:, **options)
      begin 
        Polycon::Store::ensure_root_exists
        raise InvalidAppointment unless appointment.valid? (date: date, professional: professional)
        raise AppointmentCreationError unless appointment = new(date: date, professional: professional, **options)
        #puts "creating Appointment for #{professional} on #{date}"
        appointment.save()
        appointment
      end


      def show(date:, professional:)
        Polycon::Store::ensure_root_exists
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
        'Date: '+self.date.to_s+ ': appt for client => '+/
         self.surname +', '+ self.name+' with: '+/
         self.professional.surname+self.professional.name
      end 

      def self.valid? (date:, professional:)
          valid_professional? && valid_date?
      end 

      protected 
      def save()
        Polycon::Store::save(self)
      end 

      def self.valid_professional?(professional)
          professional && professional.valid?
          true 
        rescue 
          false 
      end   

      def self.valid_date?(date)
          Date.strptime(date.to_s, FORMAT)  
          true 
        rescue 
          false 
      end
    end
  end
end
