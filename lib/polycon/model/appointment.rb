# frozen_string_literal: true

module Polycon
  module Model

    class Appointment
      FORMAT = '%Y-%m-%d-%H-%M'
      attr_accessor :date, :professional, :name,  :surname, :phone, :notes

      def self.all()
        Polycon::Store::ensure_root_exists
        Polycon::Store::
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
        raise AppointmentCreationError unless appointment = new(date: date, professional: professional, options)
        raise InvalidAppointment unless appointment.valid? (date: self.date, professional: self.professional)
        #puts "creating Appointment for #{professional} on #{date}"
        appointment.save()
        appointment
      end

      def self.all()
      end 

      def show(date:, professional:)
      end

      def cancel(date:, professional:)
      end

      def cancel_all(professional:)

      end

      def list(profesional:)
      end

      def reschedule(old_date:, new_date:, professional:)
      end

      def edit(date:, professional:, **options)
      end

      def to_s 
        date.to_s + ' => ' + surname +', '+ name + ' with ' professional.to_s 
      end 

      def valid? (date:, professional:)
          valid_professional? && valid_date?
      end 

      protected 
      def valid_professional?()
          professional && professional.valid?
          true 
        rescue 
          false 
      end   

      def self.valid_date?()
          Date.strptime(date.to_s, FORMAT)  
          true 
        rescue 
          false 
      end
    end
  end
end
