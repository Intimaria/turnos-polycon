module Polycon
  module Commands
    module Exports
      class Day < Dry::CLI::Command
        desc 'Export appointments for a day, optionally filter by professional'

        argument :date, required: true, desc: 'Date for the exports'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16" --professional="Alma Estevez" # Exports all of the appointment with Alma Estevez on the specified date'
        ]

        def call(date:, professional: nil, **options)
          begin
            if professional
              appts = professional.appointments
            else
              all = Polycon::Model::Professional.all()
              all.map! do |prof|
                prof.appointments
              end
            end
            date = Date.parse(date)
            puts all
            all.filter! do |appt|
              Date.parse(appt.date.to_s) == date
            end
            Polycon::Export.export_day(appointments: all)
          rescue Exception => e
            warn "sorry, something went wrong with Exports: #{e.message}"
            exit 1
          rescue ArgumentError, NoMethodError => e
            warn "Please check the parameters you have entered, it's possible there is a problem. #{e.message}"
            exit 2
          end
        end
      end

      class Week < Dry::CLI::Command
        desc 'Exports all appointments for a week, optionally filter by professional'

        argument :date, required: true, desc: 'Date for the exports'
        option :professional, required: false, desc: 'Full name of the professional'

        def call(date:, professional: nil, **options)
          begin
            if professional
              appts = professional.appointments
            else
              all = Polycon::Model::Professional.all()
              all.map! do |prof|
                prof.appointments
              end
            end
            date = Date.parse(date)
            monday = now - (now.wday - 1) % 7
            puts appts
            all.filter! do |appt|
              Date.parse(appt.date.to_s).between?(monday, monday + 6)
            end
            Polycon::Export.export_week(appointments: all)
          rescue Exception => e
            warn "sorry, something went wrong with Exports: #{e.message}"
            exit 1
          rescue ArgumentError, NoMethodError => e
            warn "Please check the parameters you have entered, it's possible there is a problem. #{e.message}"
            exit 2
          end
        end
      end
    end
  end
end
