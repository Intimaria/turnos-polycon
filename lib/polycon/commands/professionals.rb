# frozen_string_literal: true

module Polycon
  module Commands
    module Professionals
      class Create < Dry::CLI::Command
        desc 'Create a professional'

        argument :name, required: true, desc: 'Full name of the professional'

        example [
          '"Alma Estevez"      # Creates a new professional named "Alma Estevez"',
          '"Ernesto Fernandez" # Creates a new professional named "Ernesto Fernandez"'
        ]

        def call(name:, **options)
          begin
            professional = Polycon::Model::Professional.create(name: name)
            professional.save
            puts "Success: created professional #{name}"
          rescue Polycon::Model::AlreadyExists
            warn "That professional already exists."
            exit 0
          rescue Polycon::Model::Error => e
            warn "sorry, something went wrong with Professional: #{e.message}"
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

      class Delete < Dry::CLI::Command
        desc 'Delete a professional (only if they have no appointments)'

        argument :name, required: true, desc: 'Name of the professional'

        example [
          '"Alma Estevez"      # Deletes a new professional named "Alma Estevez" if they have no appointments',
          '"Ernesto Fernandez" # Deletes a new professional named "Ernesto Fernandez" if they have no appointments'
        ]

        def call(name:)
          begin
            # Polycon::Model::Professional.delete(name: name)
            professional = Polycon::Model::Professional.find(name: name)
            professional.delete
            puts "Success: deleted professional #{name}"
          rescue Polycon::Model::Error => e
            warn "sorry, something went wrong with Professional: #{e.message}"
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
        desc 'List professionals'

        example [
          "          # Lists every professional's name"
        ]

        def call(*)
          begin
            puts Polycon::Model::Professional.all().sort
          rescue Polycon::Model::Error => e
            warn "sorry, something went wrong with Professional: #{e.message}"
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

      class Rename < Dry::CLI::Command
        desc 'Rename a professional'

        argument :old_name, required: true, desc: 'Current name of the professional'
        argument :new_name, required: true, desc: 'New name for the professional'

        example [
          '"Alna Esevez" "Alma Estevez" # Renames the professional "Alna Esevez" to "Alma Estevez"'
        ]

        def call(old_name:, new_name:, **)
          begin
            # Polycon::Model::Professional.rename(old_name:old_name, new_name: new_name)
            professional = Polycon::Model::Professional.find(name: old_name)
            professional.rename(new_name: new_name)
            puts "Success: professional #{old_name} renamed to #{new_name}"
          rescue Polycon::Model::Error => e
            warn "sorry, something went wrong with Professional: #{e.message}"
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

      class Appointments < Dry::CLI::Command
        desc 'get appointments for a professional'

        argument :name, required: true, desc: 'name of the professional'

        example [
          '"Alna Esevez" # Shows appointments for professional "Alna Esevez"'
        ]

        def call(name:, **)
          begin
            # Polycon::Model::Professional.rename(old_name:old_name, new_name: new_name)
            professional = Polycon::Model::Professional.find(name: name)
            professional.appointments? && professional.appointments.each { |a| puts a.to_s }
          rescue Polycon::Model::Error => e
            warn "sorry, something went wrong with Professional: #{e.message}"
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
