# frozen_string_literal: true

module Polycon
  module Model
    class Professional
      attr_accessor :name, :surname, :path

    class << self 

      def all()
        Polycon::Store::ensure_root_exists
        puts Polycon::Store::PATH
        Polycon::Store::entries(directory: Polycon::Store::PATH)
      end 

      def create(name:, **)
        Polycon::Store::ensure_root_exists
        firstname, surname = name.split(" ")
        professional = new(name: firstname, surname: surname)
        raise InvalidProfessional unless valid?(professional)
        professional
      end

      # utility 

      def valid?(professional)
        professional && !professional.name.nil? && !professional.surname.nil?
      end  

    end 

      def initialize(name:, surname:)
        raise ParameterError if (name.nil? || surname.nil?)
        self.name = name
        self.surname = surname
        self.path = (@name + "_" + @surname + '/').upcase
      end

      def to_h 
        {:name=>name, :surname=>surname}
      end 

      def has_appointments?
        Polycon::Store::ensure_root_exists
        !Polycon::Store::empty?(directory: self.path)
      end 

      def rename(new_name:)
        Polycon::Store::ensure_root_exists
        new_professional = Professional.create(name:new_name)
        raise InvalidProfessional unless Professional.valid?(new_professional)
        Polycon::Store.rename(old_name:@path, new_name: new_professional.path)
      end

      def delete()
        Polycon::Store::ensure_root_exists
        Polycon::Store::delete(@path) unless self.has_appointments?
      end

      def to_s
        "name: " + (@name + " " + @surname) + " => file path: " + Polycon::Store::PATH+self.path
      end 


      def save()
        Polycon::Store::save(professional:self)
      end 

    end

    #Professional Errors
    class ProfessionalError <Error 
      def message; end; end 

    class ProfessionalCreationError < ProfessionalError
      def message 
        "Could not create professional."
      end 
    end 
    class ProfessionalRenameError < ProfessionalError
      def message 
        "Could not rename professional."
      end 
    end 

    class InvalidProfessional < ProfessionalError 
      def message 
        'the professional is invalid. Please revise'
      end 
    end 

  end
end
