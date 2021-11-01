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

      class << self
        def all
          collection = Professional.all
          collection.map! do |prof|
            prof.appointments.sort_by {|a| a.date}
          end.flatten
        end

<<<<<<< HEAD
        # def all_for_professional(prof)
        #   # TODO maybe have professional know their appointments, or store return
         
        #   raise InvalidProfessional unless Professional.valid?(prof)
        #   prof.appointments
        #   #appointments = Polycon::Store.all_appointment_dates_for_prof(prof)
        #   #appointments.map! { |date| Appointment.from_file(date: date, professional: prof.to_s) }
        # end

        def create(date:, professional:, **options)
          raise AppointmentCreationError unless (appointment = new(date: date, professional: professional, **options))

          raise InvalidAppointment unless valid?(date: appointment.date, professional: appointment.professional)

=======
        def all(professional:, date: nil)
          Polycon::Store.ensure_root_exists
          prof = Professional.create(name: professional)
          raise InvalidProfessional unless Professional.valid?(prof)
          appointments  = Polycon::Store.entries(directory:Polycon::Store::PATH+prof.path)
          appointments.map! do |appt| 
            date_arr = appt.split(/_/)
            time = date_arr[1].gsub(/[-]/,":")
            date_arr[0]+"_"+time
          end 
          all = []
          appointments.each {|date| all << Appointment.from_file(date: date, professional: professional)}
          all.sort_by { |a| a.date }
        end 

        def create(date:, professional:, **options)
          begin 
            Polycon::Store.ensure_root_exists
            path = make_path(professional: professional, date: date)
            raise AppointmentCreationError unless appointment = new(date: date, professional: professional, **options)
            valid?(date: appointment.date, professional: appointment.professional)
            appointment
          end
        end 

        def from_file(date:, professional:)
          Polycon::Store.ensure_root_exists
          path = make_path(professional: professional, date: date)
          raise NotFound unless Polycon::Store.exist?(path)
          surname, name, phone, notes = Polycon::Store.read(path)
          appointment = create(date:date, professional:professional, name:name, surname:surname, phone:phone, notes:notes)
>>>>>>> development
          appointment
        end

        def from_file(date:, professional:)
          surname, name, phone, notes = Polycon::Store.read(professional: Professional.create(name: professional),
                                                            date: Time.parse(date))
          create(date: date, professional: professional, name: name, surname: surname, phone: phone, notes: notes)
        end

        def cancel_all(professional:)
<<<<<<< HEAD
          prof = Professional.create(name: professional)
          (all_appointments = prof.appointments) if prof.appointments?
          all_appointments.each &:cancel
=======
          Polycon::Store.ensure_root_exists
          prof = Professional.create(name: professional)
          raise NotFound if Polycon::Store.empty?(directory:prof.path)
          all_appointments = all(professional: professional)
          all_appointments.each {|appt| appt.cancel}
>>>>>>> development
        end

        # utility

        protected

        def valid?(date:, professional:)
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
            Time.strptime(date.to_s, '%Y-%m-%d %H:%M')
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
          send(:"#{key}=", value)
        end
      end

      def to_h
        {
          professional: professional,
          date: date.strftime('%Y-%m-%d'),
          hour: date.strftime('%H:%M'),
          surname: surname,
          name: name,
          phone: phone,
          notes: notes
        }
      end

      def edit(**options)
<<<<<<< HEAD
        Polycon::Store.modify(self, **options)
=======
        Polycon::Store.ensure_root_exists
        Polycon::Store.modify(file: self, **options)
      end 
      def cancel()
        Polycon::Store.ensure_root_exists
        Polycon::Store.delete(@path)
        raise AppointmentDeletionError if Polycon::Store.exist?(@path)
>>>>>>> development
      end

      def cancel
        Polycon::Store.delete_appointment(self)
        raise AppointmentDeletionError if Polycon::Store.exist_appointment?(self)
      end

      def reschedule(new_date:)
<<<<<<< HEAD
        copy = self.dup
        copy.date = Time.parse(new_date)
        raise AlreadyExists if Polycon::Store.exist_appointment?(copy)

        Polycon::Store.rename_appointment(old_app: self, new_app: copy)
=======
        Polycon::Store.ensure_root_exists
        new_path = Appointment.make_path(professional:self.to_h[:professional], date: new_date)
        raise AlreadyExists if Polycon::Store.exist?(new_path)
        Polycon::Store.rename(old_name: @path, new_name: new_path)
>>>>>>> development
      end

      def to_s
        s = String.new
        to_h.map { |key, value| s << "#{key}: #{value} " }
        s
<<<<<<< HEAD
      end

      def save
        # TODO - should I have this in create, in initialize or in save?
        # should I call save in create? Makes more sense
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
=======
      end 

      def save()
        Polycon::Store.ensure_root_exists
        raise AlreadyExists if Polycon::Store.exist?(@path)
        Polycon::Store.save(appointment: self)
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
>>>>>>> development
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
