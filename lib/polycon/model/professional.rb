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

      def rename(old_name:, new_name:)
        Polycon::Store::ensure_root_exists
        old_professional = create(name:old_name)
        new_professional = create(name:new_name)
        raise InvalidProfessional unless valid?(old_professional)
        raise InvalidProfessional unless valid?(new_professional)
        Polycon::Store.rename(old_name: old_professional, new_name: new_professional)
      end

      def delete(name:)
        Polycon::Store::ensure_root_exists
        professional = create(name: name)
        Polycon::Store::_delete(professional) unless professional.has_appointments?
      end


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
        {}:name=>name, :surname=>surname}
      end 

      def has_appointments?
        Polycon::Store::ensure_root_exists
        !Polycon::Store::empty?(directory: self.path)
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
