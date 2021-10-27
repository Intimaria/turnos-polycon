# frozen_string_literal: true

module Polycon
  module Commands
    module Appointments
      class Create < Dry::CLI::Command
        desc 'Create an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'
        option :name, required: true, desc: "Patient's name"
        option :surname, required: true, desc: "Patient's surname"
        option :phone, required: true, desc: "Patient's phone number"
        option :notes, required: false, desc: 'Additional notes for appointment'

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" --name=Carlos --surname=Carlosi --phone=2213334567'
        ]

        def call(date:, professional:, name:, surname:, phone:, notes: nil)
          #warn "TODO: Implementar creación de un turno con fecha '#{date}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
          begin
            appointment = Polycon::Model::Appointment.create(date:date, professional:professional, name:name, surname:surname, phone:phone, notes:notes)
            appointment.save
            puts "Sucess: created appointment for #{appointment.date}"
          rescue Polycon::Model::AlreadyExists
            warn "That appointment already exists."
            exit 0 
          rescue Polycon::Model::Error => e
            warn "sorry, something went wrong: #{e.message}"
            exit 1
          rescue Dry::Files::Error => e 
            warn "sorry, something went wrong with Store: #{e.message}"
            exit 2
          rescue ArgumentError, NoMethodError => e 
            warn "You may have entered a non-existent time, please check your parameters and try again"
            exit 3
          end
        end
      end

      class Show < Dry::CLI::Command
        desc 'Show details for an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" # Shows information for the appointment with Alma Estevez on the specified date and time'
        ]

        def call(date:, professional:)
          #warn "TODO: Implementar detalles de un turno con fecha '#{date}' y profesional '#{professional}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
          begin
            appointment = Polycon::Model::Appointment.from_file(date: date, professional: professional)
            puts "Showing appointment - "
            puts "#{appointment}"
          rescue Polycon::Model::NotFound
            warn "That appointment doesn't exist."
            exit 0 
          rescue Polycon::Model::Error => e
            warn "sorry, something went wrong: #{e.message}"
            exit 1
          rescue Dry::Files::Error => e 
            warn "sorry, something went wrong with Store: #{e.message}"
            exit 2 
          rescue ArgumentError, NoMethodError => e 
            warn "Please check the parameters you have entered, it's possible there is a problem. #{e.message}"
            exit 3
          end
        end
      end

      class Cancel < Dry::CLI::Command
        desc 'Cancel an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" # Cancels the appointment with Alma Estevez on the specified date and time'
        ]

        def call(date:, professional:)
          #warn "TODO: Implementar borrado de un turno con fecha '#{date}' y profesional '#{professional}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
          begin
            #Polycon::Model::Appointment.cancel(date:date , professional: professional)
            appointment = Polycon::Model::Appointment.from_file(date: date, professional: professional)
            appointment.cancel
            puts "Cancellation successful"
          rescue Polycon::Model::NotFound
            warn "That appointment doesn't exist."
            exit 0
          rescue Polycon::Model::Error => e
            warn "sorry, something went wrong with Appointment: #{e.message}"
            exit 1
          rescue Dry::Files::Error => e 
            warn "sorry, something went wrong with Store: #{e.message}"
            exit 2
          rescue ArgumentError, NoMethodError => e 
            warn "Please check the parameters you have entered, it's possible there is a problem. #{e.message}"
            exit 3
          end
        end
      end

      class CancelAll < Dry::CLI::Command
        desc 'Cancel all appointments for a professional'

        argument :professional, required: true, desc: 'Full name of the professional'

        example [
          '"Alma Estevez" # Cancels all appointments for professional Alma Estevez'
        ]

        def call(professional:)
          warn# "TODO: Implementar borrado de todos los turnos de la o el profesional '#{professional}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
          begin
            Polycon::Model::Appointment.cancel_all(professional: professional)
            puts "Success: you have cancelled all appointments for #{professional}"
          rescue Polycon::Model::NotFound
            warn "There are no appointments for that professional"
            exit 0
          rescue Polycon::Model::Error  => e
            warn "sorry, something went wrong with Appointment: #{e.message}"
            exit 1
          rescue Dry::Files::Error => e 
            warn "sorry, something went wrong with Store: #{e.message}"
            exit 2
          rescue ArgumentError, NoMethodError => e 
            warn "Please check the parameters you have entered, it's possible there is a problem. #{e.message}"
            exit 3
          end
        end
      end

      class List < Dry::CLI::Command
        desc 'List appointments for a professional, optionally filtered by a date'

        argument :professional, required: true, desc: 'Full name of the professional'
        option :date, required: false, desc: 'Date to filter appointments by (should be the day)'
        # def call(professional:, date: nil)
        example [
          '"Alma Estevez" # Lists all appointments for Alma Estevez',
          '"Alma Estevez" --date="2021-09-16" # Lists appointments for Alma Estevez on the specified date'
        ]

        def call(professional:, **options)
          #warn "TODO: Implementar listado de turnos de la o el profesional '#{professional}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
          begin
            appts = Polycon::Model::Appointment.all(professional:professional, **options)
            options[:date] && appts = appts.select { |appt| appt.date == options[:date] }
            if appts.empty?
              warn "No appointments for #{professional}"
              exit 0
            end
          rescue Polycon::Model::Error => e
            warn "sorry, something went wrong with Appointment: #{e.message}"
            exit 1
          rescue Dry::Files::Error => e 
            warn "sorry, something went wrong with Store: #{e.message}"
            exit 2
          rescue ArgumentError, NoMethodError => e 
            warn "Please check the parameters you have entered, it's possible there is a problem. #{e.message}"
            exit 3
          end
        end
      end

      class Reschedule < Dry::CLI::Command
        desc 'Reschedule an appointment'

        argument :old_date, required: true, desc: 'Current date of the appointment'
        argument :new_date, required: true, desc: 'New date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" "2021-09-16 14:00" --professional="Alma Estevez" # Reschedules appointment on the first date for professional Alma Estevez to be now on the second date provided'
        ]

        def call(old_date:, new_date:, professional:)
          #warn "TODO: Implementar cambio de fecha de turno con fecha '#{old_date}' para que pase a ser '#{new_date}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
          begin
            #Polycon::Model::Appointment.reschedule(old_date: old_date, new_date: new_date, professional: professional)
            appointment = Polycon::Model::Appointment.from_file(date: old_date, professional: professional)
            appointment.reschedule(new_date: new_date)
            puts "Success: you have rescheduled appointment with #{professional}  for #{new_date}"
          rescue Polycon::Model::NotFound
            warn "That appointment doesn't exist."
            exit 0
          rescue Polycon::Model::Error => e
            warn "sorry, something went wrong with Appointment: #{e.message}"
            exit 1
          rescue Dry::Files::Error => e 
            warn "sorry, something went wrong with Store: #{e.message}"
            exit 2
          rescue ArgumentError, NoMethodError => e 
            warn "Please check the parameters you have entered, it's possible there is a problem. #{e.message}"
            exit 3
          end
        end
      end

      class Edit < Dry::CLI::Command
        desc 'Edit information for an appointments'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'
        option :name, required: false, desc: "Patient's name"
        option :surname, required: false, desc: "Patient's surname"
        option :phone, required: false, desc: "Patient's phone number"
        option :notes, required: false, desc: 'Additional notes for appointment'

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" --name="New name" # Only changes the patient\'s name for the specified appointment. The rest of the information remains unchanged.',
          '"2021-09-16 13:00" --professional="Alma Estevez" --name="New name" --surname="New surname" # Changes the patient\'s name and surname for the specified appointment. The rest of the information remains unchanged.',
          '"2021-09-16 13:00" --professional="Alma Estevez" --notes="Some notes for the appointment" # Only changes the notes for the specified appointment. The rest of the information remains unchanged.'
        ]

        def call(date:, professional:, **options)
          #warn "TODO: Implementar modificación de un turno de la o el profesional '#{professional}' con fecha '#{date}', para cambiarle la siguiente información: #{options}.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."

          begin
            appointment = Polycon::Model::Appointment.from_file(professional: professional, date:date)
            appointment.edit(**options)
            puts "Success: you have edited appointment on date #{date}"
          rescue Polycon::Model::NotFound
            warn "That appointment doesn't exist."
            exit 0
          rescue Polycon::Model::Error => e
            warn "sorry, something went wrong with Appointment: #{e.message}"
            exit 1
          rescue Dry::Files::Error => e 
            warn "sorry, something went wrong with Store: #{e.message}"
            exit 2
          rescue ArgumentError, NoMethodError => e 
            warn "Please check the parameters you have entered, it's possible there is a problem. #{e.message}"
            exit 3
          end
        end
      end
    end
  end
end
