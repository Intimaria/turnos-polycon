require 'date'
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
            # appts = Polycon::Model::Professional.all()
            # appts.map! do |prof|
            #   prof.appointments
            # end
            # appts.flatten!
            # puts appts
            Polycon::Export.export_day(professional: professional, date: date)
          rescue Exception => e # TODO change - update to ExportError later
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

        def call(date:, professional: nil)
          begin
              if professional
                all = professional.appointments
              else
                all = Polycon::Model::Professional.all()
                all.map! do |prof|
                  prof.appointments
                end
              end
              now = Date.parse(date)
              monday = now - (now.wday - 1) % 7
              puts all
              all.flatten!
              all.filter! do |appt|
                Date.parse(appt.date.to_s).between?(monday, monday + 6)
              end
              puts "after"
              puts all
            Polycon::Export.export_week(date: date, professional: professional)
          rescue Exception => e # TODO change - update to ExportError later
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
