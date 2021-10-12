# frozen_string_literal: true

module Polycon
  module Model
    class Professional
      attr_accessor :name, :surname
      attr_reader :path

    class << self 

      def all()
        Polycon::Store::ensure_root_exists
        Polycon::Store::entries(directory: Polycon::Store::PATH).map! {|p| p.gsub(/_/, " ") }.sort
      end 

      def create(name:, **)
        Polycon::Store::ensure_root_exists
        firstname, surname = name.split(" ")
        professional = new(name: firstname, surname: surname)
        raise InvalidProfessional unless valid?(professional)
        professional
      end

      def find(name:, **)
        Polycon::Store::ensure_root_exists
        firstname, surname = name.split(" ")
        professional = new(name: firstname, surname: surname)
        raise NotFound unless Polycon::Store::exist?(professional.path)
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
        @path = (@name + "_" + @surname + '/').upcase
      end

      def to_h 
        {:name=>name, :surname=>surname}
      end 

      def has_appointments?
        Polycon::Store::ensure_root_exists
        !Polycon::Store::empty?(directory: @path)
      end 

      def rename(new_name:)
        Polycon::Store::ensure_root_exists
        new_professional = Professional.create(name:new_name)
        raise InvalidProfessional unless Professional.valid?(new_professional)
        Polycon::Store::rename(old_name:@path, new_name: new_professional.path)
      end

      def delete()
        Polycon::Store::ensure_root_exists
        raise ProfessionalDeletionError if self.has_appointments? 
        Polycon::Store::delete(@path)
      end

      def to_s
        "name: " + (@name + " " + @surname) + "\nfile path: " + Polycon::Store::PATH+@path
      end 

      def save()
        Polycon::Store::ensure_root_exists
        raise AlreadyExists if Polycon::Store::exist?(@path)
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

    class ProfessionalDeletionError < ProfessionalError
      def message 
        "Could not delete professional as they have appointments."
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
