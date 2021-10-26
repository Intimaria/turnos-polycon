module Polycon
    module Commands
      module Exports
        
        class Day < Dry::CLI::Command
            desc 'Expory appointments for a day'

            argument :date, required: true, desc: 'Date for the exports'
            option :professional, required: true, desc: 'Full name of the professional'

            example [
            '"2021-09-16" --professional="Alma Estevez" # Exports all of the appointment with Alma Estevez on the specified date'
            ]
    
            def call(date:, professional: nil,  **options)
              warn "TODO: Implementar exportacion de turnos para el dia.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
              begin
                puts professional.appointments() if professional
              rescue Polycon::Exports::Error => e
                warn "sorry, something went wrong with Exports: #{e.message}"
                exit 1
              rescue ArgumentError, NoMethodError => e 
                warn "Please check the parameters you have entered, it's possible there is a problem. #{e.message}"
                exit 2
              end
            end
          end
  
        class Week < Dry::CLI::Command
            desc 'Exports all appointments for a week'

            argument :date, required: true, desc: 'Date for the exports'
            option :professional, required: false, desc: 'Full name of the professional'

  
          def call(date:,professional: nil,  **options)
            warn "TODO: Implementar exportaciones de turnos por semana.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
            begin
              puts professional.appointments() if professional
            rescue Polycon::Exports::Error => e
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
  