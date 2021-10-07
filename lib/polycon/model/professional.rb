# frozen_string_literal: true

module Polycon
  module Model
    class Professional
      attr_accessor :name, :surname, :path

      def initialize(name, surname)
        self.name = name
        self.surname = surname
        self.path = (@name + "_" + @surname).upcase
      end

      def self.create(name:, **)
        Polycon::Storage.create_root unless Polycon::Storage.root_exist? 
        firstname, surname = name.split(" ")
        raise ProfessionalCreationError unless professional = new(name, surname)
        Polycon::Storage.save(professional: professional.path)
        professional
      end


      def delete(name: nil)
        # etc
      end

      def delete_all_appointments 
      end 

      def list(*)
        # etc
      end

      def rename(old_name:, new_name:, **)
        Polycon::Storage.rename(old_name: old_name.path, new_name: new_name.path, professional: "true")
        # etc
      end

      def to_s
        "name: " + (@name + " " + @surname).upcase + " => file path: " + Storage::ROOT_DIR+self.path
      end 


      class ProfessionalCreationError < StandardError
        def message 
          "Could not create professional."
        end 
      end 
      class ProfessionalRenameError < StandardError
        def message 
          "Could not rename professional."
        end 
      end 

    end
  end
end
